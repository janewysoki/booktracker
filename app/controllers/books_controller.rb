class BooksController < ApplicationController
    
    #index route for all books
    get '/books' do
        @books = Book.all #have to use an instance variable and not a local variable here because the scope of a local variable isn't to the class, but to the method they're part of
        erb :'/books/index' #this is rendering to a file reference, we redirect to routes
    end

    #get books/new to render a form to create new entry
    get '/books/new' do #get reqeusts show something exists
        erb :'/books/new'
    end

    #post books to create a new book
    post '/books' do
    #want to create new book and save it to db
    #first let's check that user is logged in - if not, redirect to homepage
        redirect_if_not_logged_in
        #now i only want to save the entry if it has some content 
        if params[:title] != "" #author and comments section can be left empty
            #then create new entry
            @book = Book.create(params) #this is mass assignment - params is a hash thats getting the key value pairs needed to create a new book
            @book.user_id = session[:user_id]
            @book.save #save to db
            flash[:message] = "You've successfully added a new book!"
            redirect "/books/#{@book.id}" #without redirect this would be a dead end
        else
            #if empty, redirect back to form
            flash[:error] = "You must enter a title to add a new book." #can change :message to :error and then style error flash messages to be red and :message ones to be green
            redirect '/books/new'
        end
    end

    #show route for a book; show/render particular book entry
    get '/books/:id' do #dynamic route - dynamic pieces of the route (:id) becomes key value pairs in the parameters
        #find book entry
        find_book #@book = Book.find(params[:id])
        #redirects destroy instance variables, and we want this instance variable to live on and be available inside show page for books
        erb :'/books/show'
    end

    #this route should send us to books/edit.erb which will render an edit form
    get '/books/:id/edit' do
        #want to find a specific book before rendering the edit form
        find_book #@book = Book.find(params[:id]) #have to pull the id from the url
        redirect_if_not_logged_in
            #make sure book entry belongs to current user
        if authorized_to_edit?(@book)
            erb :'/books/edit'
        else #redirect them to their homepage (show page)
            flash[:error] = "You are not authorized to edit this book."
            redirect "/users/#{current_user.id}"
        end
    end

    #this is a brand new action, i don't have access to the instance variable anymore
    patch '/books/:id' do
        find_book
        redirect_if_not_logged_in
        if authorized_to_edit?(@book) && params[:title] != ""
            #modify (update) the book; gonna use active records methods to update book entry
            @book.update(title: params[:title], author: params[:author], comments: params[:comments]) #this is actually a hash of key value pairs
            #redirect to show page
            redirect "/books/#{@book.id}"
        else
            redirect "/users/#{current_user.id}" #redirect to their homepage
        end
    end

    #this action's job is simply to delete a book entry
    delete '/books/:id' do
        find_book #gets me the instance variable?
        #redirect_if_not_logged_in DO I NEED THIS?
        if authorized_to_edit?(@book) #don't have to use logged_in method since authorized to edit implies the user is already logged in
            #delete the entry
            #diff between delete and destroy is destroy runs callbacks on the method and removes associated children while delete doesn't
            #callbacks are methods invoked at certain times, certain life cycles events will invoke a call back
            @book.destroy
            flash[:message] = "Book successfully deleted."
            redirect '/books' 
        else
            #go somehwere else not deleted
            redirect '/books'
        end
    end

    # i see that this line of code: @book = Book.find(params[:id]) is used multiple times so i should create a helper method
    private #WHY IS THIS PRIVATE? #CAN THIS BE A HELPER METHOD?
        def find_book
            @book = Book.find(params[:id])
        end
end



#because im inside a books controller method, thats why i still have access to params. params is made available to my books controller class and every time we send new page refresh, we get a new instance of this class

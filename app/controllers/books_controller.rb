class BooksController < ApplicationController
    #get books/new to render a form to create new entry
    get '/books/new' do #get reqeusts show something exists
        erb :'/books/new'
    end

    #post books to create a new book
    post '/books' do
    #want to create new book and save it to db
    #how to check if incoming data has content
    #only want to create book if a user is logged in
    #first let's check that user is logged in - if not, redirect to homepage
        #if !logged_in?
            #redirect '/'
        #end
        #now i only want to save the entry if it has some content 
        if params[:title] != "" #author and comments section can be left empty
            #then create new entry
            @book = Book.create(params) #this is mass assignment - params is a hash thats getting the key value pairs needed to create a new book
            #@book = Book.create(title: params[:title], author: params[:author], comments: params[:comments], user_id: current_user.id)
            redirect "/books/#{@book.id}" #without redirect this would be a dead end
        else
            #if empty, redirect back to form
            #ADD FLASH MESSAGE
            redirect '/books/new'
        end
    end

    #show route for a book

    #index route for all books
end
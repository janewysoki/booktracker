class BooksController < ApplicationController
    
    get '/books' do
        @books = Book.all 
        erb :'/books/index'
    end

    get '/books/new' do 
        erb :'/books/new'
    end

    post '/books' do
        redirect_if_not_logged_in
        if params[:title] != "" 
            @book = Book.create(params) 
            @book.user_id = session[:user_id]
            @book.save 
            flash[:message] = "You've successfully added a new book!"
            redirect "/books/#{@book.id}" 
        else
            flash[:error] = "You must enter a title to add a new book." 
            redirect '/books/new'
        end
    end

    get '/books/:id' do 
        find_book 
        erb :'/books/show'
    end

    get '/books/:id/edit' do
        find_book 
        redirect_if_not_logged_in
        if authorized_to_edit?(@book)
            erb :'/books/edit'
        else 
            flash[:error] = "You are not authorized to edit this book."
            redirect "/users/#{current_user.id}"
        end
    end

    patch '/books/:id' do
        find_book
        redirect_if_not_logged_in
        if authorized_to_edit?(@book) && params[:title] != ""
            @book.update(title: params[:title], author: params[:author], comments: params[:comments])
            redirect "/books/#{@book.id}"
        else
            redirect "/users/#{current_user.id}"
        end
    end

    delete '/books/:id' do
        find_book 
        if authorized_to_edit?(@book) 
            @book.destroy
            flash[:message] = "Book successfully deleted."
            redirect '/books' 
        else
            redirect '/books'
        end
    end

    private 
        def find_book
            @book = Book.find(params[:id])
        end
end
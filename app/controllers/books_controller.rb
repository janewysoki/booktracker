class BooksController < ApplicationController
    #get books/new to render a form to create new entry
    get '/books/new' do #get reqeusts show something exists
        erb :'/books/new'
    end
    #post books to create a new book
    post '/books' do
        
    end
    #show route for a book

    #index route for all books
end
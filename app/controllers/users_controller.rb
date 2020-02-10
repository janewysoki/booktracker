class UsersController < ApplicationController
    #what routes do i need for login?
    #purpose of this route is to render login page/form
    get '/login' do
        erb :'users/login'
    end

    #what routes do i need for signup?
    get '/signup' do
    end
end
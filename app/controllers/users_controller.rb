class UsersController < ApplicationController

    get '/login' do
        erb :'/users/login'
    end

    post '/login' do
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password]) 
            session[:user_id] = @user.id 
            #puts session
            flash[:message] = "Welcome, #{@user.username}!" 
            redirect "users/#{@user.id}" 
        else
            flash[:error] = "You've entered invalid credentials. Please sign up or try again."
            redirect '/login'
        end
    end

    get '/signup' do
        erb :'/users/signup'
    end

    post '/users' do
        if @user.save 
            session[:user_id] = @user.id 
            flash[:message] = "Thanks for creating an account, #{@user.username}! Welcome." 
            redirect "/users/#{@user.id}" 
        else
            flash[:error] = "Account creation failure: #{@user.errors.full_messages.to_sentence}."
            redirect '/signup' 
        end
    end

    get '/users/:id' do 
        @user = User.find_by(id: params[:id])
        redirect_if_not_logged_in
        erb :'/users/show'
    end

    get '/logout' do
        session.clear 
        redirect '/' 
    end
end
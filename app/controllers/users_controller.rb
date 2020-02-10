class UsersController < ApplicationController
    #what routes do i need for login?
    #purpose of this route is to render login page/form
    get '/login' do
        erb :'users/login'
    end

    #here we're creating a session/adding a key value pair to session hash
    #purpose of this route is to receive login form, find the user and log the user in
    post '/login' do
        #irght now params = {username: "username", password: "password"}
        #find_by expects key value pair
        #find the user
        @user = User.find_by(username: params[:username])
        #authenticate the user - verify the user is who they say they are and make sure they're in database/that they have credentials (username password combo)
        if @user.authenticate(params[:password]) #either returns a user or returns false
            #log the user in - create the user session
            #add key value pair to session hash
            session[:user_id] = @user.id #this is actually logging the user in
            #redirect to the user's show page (show? index? dashboard?)
            redirect "users/#{@user.id}" #pass in user id to match the show route below
        else
            #tell user they entered invalid credentials
            #redirect them to login page
        end
       
    end

    #what routes do i need for signup?
    get '/signup' do
    end



    #user SHOW route
    get '/users/:id' do
        #this will be user show route
    end
end
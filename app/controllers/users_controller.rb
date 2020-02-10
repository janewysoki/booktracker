class UsersController < ApplicationController
    #what routes do i need for login?
    #purpose of this route is to render login page/form
    get '/login' do
        erb :'/users/login'
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
            #redirect to the user's show page
            redirect "users/#{@user.id}" #pass in user id to match the show route below
        else
            #tell user they entered invalid credentials
            #redirect them to login page
            #redirect '/users/login'
        end
       
    end

    #what routes do i need for signup?
    #this route's job is to render a signup form (aka place to enter credentials and sign up)
    get '/signup' do
        erb :'/users/signup'
    end

    post '/users' do
        #here is where we will create a new user and persist that new user to the database
        #params will look like: {"email" => "jane@jane.com", "username => "jane", "password" => "1234"}
        #only want to persist a user that has an email, username, and password
        if params[:email] != "" && params[:username] != "" && params[:password] != "" #if all fields aren't empty strings
            #valid input
            @user = User.create(params) 
            #where do I go now? user show page?
            redirect "/users/#{@user.id}" #grab actual users id and redirect to their specific show page
                #with redirect we write the url of the request we're sending; new http request
                #this is better choice than rendering to erb because
                #when we redirect, we want to send a get request to get data we're looking for; separation of concerns; every route should have 1 job
                #only job of this route is to create new user, NOT show us new user
                #render happens from get requests
                #what do we get access to when we render a page with erb? you get access to any instance variable created within the same block before erb is called
        else
            #not valid imput
        end
    end

    #user SHOW route
    get '/users/:id' do #aka users/1 (or any id number) in the url bar #:id piece of url is dynamic (changes from one user to another)
        #this will be user show route
        @user = User.find_by(id: params[:id])
        erb :'/users/show' #this shows us the new user
    end
end
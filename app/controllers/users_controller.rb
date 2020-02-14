class UsersController < ApplicationController

    #purpose of this route is to render login page/form
    get '/login' do
        erb :'/users/login'
    end

    #purpose of this route is to receive login form, find the user and log the user in
    post '/login' do
        #irght now params = {username: "username", password: "password"}
        #find_by expects key value pair
        #find the user
        @user = User.find_by(username: params[:username])
        #authenticate the user - verify the user is who they say they are and make sure they're in database/that they have credentials (username password combo)
        if @user && @user.authenticate(params[:password]) #either returns a user or returns false
            #WHY @user && @user.... above???
            #log the user in - create the user session
            #add key value pair to session hash
            session[:user_id] = @user.id #this is actually logging the user in
            puts session #WHY DO I NEED THIS
            #redirect to the user's show page
            flash[:message] = "Welcome, #{@user.username}!" #don't need this
            redirect "users/#{@user.id}" #pass in user id to match the show route below
        else
            #tell user they entered invalid credentials
            flash[:error] = "You've entered invalid credentials. Please sign up or try again."
            redirect '/login'
        end
       
    end

    #this route's job is to render a signup form (aka place to enter credentials and sign up)
    get '/signup' do
        erb :'/users/signup'
    end

    post '/users' do
        #here is where we will create a new user and persist that new user to the database
        #params will look like: {"email" => "jane@jane.com", "username => "jane", "password" => "1234"}
        #only want to persist a user that has an email, username, and password
        @user = User.create(params) #should this be new?
        if @user.save #this will return true or false
            #now let's just log the person in since they signed up (instead of redirecting to login page)
            session[:user_id] = @user.id #this actually logs user in
            #creating a key on the sessions hash called user_id and assigning it to the users id that just signed up
            flash[:message] = "Thanks for creating an account, #{@user.username}! Welcome." #flash message will only work if you end with a redirect cause only a redirect sends a new HTTP request! NOT with an erb
            #where do I go now? user show page?
            redirect "/users/#{@user.id}" #grab actual users id and redirect to their specific show page
                #with redirect we write the url of the request we're sending; new http request
                #when we redirect, we want to send a get request to get data we're looking for; separation of concerns; every route should have 1 job
                #only job of this route is to create new user, NOT show us new user
                #render happens from get requests
                #what do we get access to when we render a page with erb? you get access to any instance variable created within the same block before erb is called
        else
            #not valid input
            flash[:error] = "Account creation failure: #{@user.errors.full_messages.to_sentence}."
            redirect '/signup' 
        end
    end

    #user SHOW route
    get '/users/:id' do #aka users/1 (or any id number) in the url bar #:id piece of url is dynamic (changes from one user to another)
        @user = User.find_by(id: params[:id])
        redirect_if_not_logged_in
        erb :'/users/show' #this shows us the new user
        #because i'm rendering/using erb, that gives me access to the @user variable inside of my view
    end

    get '/logout' do
        session.clear #session is where we log someone in or out
        redirect '/' 
    end
end
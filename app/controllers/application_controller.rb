require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  #use Rack::Flash

  configure do
    set :public_folder, 'public' #relates to if i include images in public folder
    set :views, 'app/views' #this is where sinatra is gonna look when i render files - it will start here
    enable :sessions
    set :session_secret, 'booklover' #this sets a session secret so a session id will be created for this particular session which allows an extra layer of security
    register Sinatra::Flash #now have access to a hash called flash where i can assign k/v pairs to a flash message and life cycle of flash message is exactly 1 http request
      #CANT USE FLASH MESSAGES INSIDE ROUTES THAT END WITH ERB
  end

  get "/" do
    #only want to show welcome page if person isn't logged in
    if logged_in?
      redirect "/users/#{current_user.id}"
    else
      erb :welcome
    end
  end

  #determine if someone is logged in
  helpers do
    def current_user #should return current user if there is one
      #find method takes in an integer and looks up the id; will return user if there is one; if find doesn't find what it is looking for it will return error
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id] #why if statement? #find_by will return nil instead of an error so we use find by instead of find
      #first time @current_user is referenced within scope of instance of app controller, this instance will be created and assigned if user is found, otherwise it will still be nil
    end

    def logged_in? #this will return boolean, if i'm going to return a boolean from a method it should end in question mark
      #should return true if user is logged in, otherwise false
      !!current_user #!! takes a value and turns it into a boolean reflection of an object's truthiness; will return true if there's a user here
    end

    def authorized_to_edit? (book) #NEED EXPLAINED
      book.user == current_user #returning true or false based on the book we passing in belonging to the current user
    end

    def valid_params?
      params[:book].none? do |k, v|
        v == ""
      end
    end
    #BUILD HELPER METHOD FOR REDIRECTING IF NOT LOGGED IN
  end
end

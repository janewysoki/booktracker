require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  use Rack::Flash

  configure do
    set :public_folder, 'public' #relates to if i include images in public folder
    set :views, 'app/views' #this is where sinatra is gonna look when i render files - it will start here
    enable :sessions
    set :sessions_secret, 'booklover' #this sets a session secret so a session id will be created for this particular session which allows an extra layer of security
  end

  get "/" do
    erb :welcome
  end

  #determine if someone is logged in
  helpers do
    def logged_in? #this will return boolean, if i'm going to return a boolean from a method it should end in question mark
      #should return true if user is logged in, otherwise false
      !!current_user #!! takes a value and turns it into a boolean reflection of an object's truthiness; will return true if there's a user here
    end

    def current_user #should return current user if there is one
      #find method takes in an integer and looks up the id; will return user if there is one; if find doesn't find what it is looking for it will return error
      @current_user ||= User.find_by(id: session[:user_id]) #find_by will return nil instead of an error so we use find by instead of find
      #first time @current_user is referenced within scope of instance of app controller, this instance will be created and assigned if user is found, otherwise it will still be nil
    end
  end


end

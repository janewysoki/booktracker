require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'booklover' 
    register Sinatra::Flash 
  end

  get "/" do
    if logged_in?
      redirect "/users/#{current_user.id}"
    else
      erb :welcome
    end
  end

  helpers do
    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def logged_in? 
      !!current_user 
    end

    def authorized_to_edit?(book) 
      book.user == current_user 
    end

    def redirect_if_not_logged_in
      if !logged_in?
        flash[:error] = "You must log in to continue."
        redirect '/'
      end
    end
  end
end

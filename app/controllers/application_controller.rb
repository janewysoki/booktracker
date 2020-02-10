require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :sessions_secret, 'booklover'
  end

  get "/" do
    erb :welcome
  end

  helpers do
    def current_user
      @user ||=User.find(session[:user_id])
    end

    def logged_in?
      !!session[:user_id]
    end
  end
end

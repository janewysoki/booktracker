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
end

class Book < ActiveRecord::Base
    belongs_to :user  #means i need user_id column in database
end
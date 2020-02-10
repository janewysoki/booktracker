class User < ActiveRecord::Base
    has_secure_password #allows us to use activerecord method 'authenticate'
    has_many :books
end
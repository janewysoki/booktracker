class User < ActiveRecord::Base
    has_secure_password #allows us to use activerecord method 'authenticate'; a macro
    validates :username, presence: true
    validates :username, uniqueness: true
    validates :email, presence: true
    validates :email, uniqueness: true #this uses AR - validates comes with AR #does this mean you can't use the same username or email?
    has_many :books
end
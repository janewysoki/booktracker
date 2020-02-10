class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.string :password_digest #becasue using bcrypt, allows bcrypt to recognize this will be column to keep encrypted passwords
    end
  end
end

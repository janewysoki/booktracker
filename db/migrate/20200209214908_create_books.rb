class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.text :comments
      t.integer :user_id
      t.timestamps
    end
  end
end

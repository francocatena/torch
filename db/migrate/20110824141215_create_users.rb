class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :lastname, null: false
      t.string :email, null: false
      t.string :crypted_password, null: false
      t.string :password_salt, null: false
      t.string :persistence_token, null: false
      t.integer :lock_version, default: 0

      t.timestamps
    end
    
    add_index :users, :email, :unique => true
  end
end
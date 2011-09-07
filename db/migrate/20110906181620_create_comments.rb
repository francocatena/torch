class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :comment, null: false
      t.references :user
      t.references :hint, null: false

      t.timestamps
    end
    
    add_index :comments, :user_id
    add_index :comments, :hint_id
  end
end
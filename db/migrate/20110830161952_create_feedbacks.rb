class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.boolean :positive, null: false, default: false
      t.text :comments
      t.references :hint, null: false

      t.timestamps
    end
    
    add_index :feedbacks, :positive
    add_index :feedbacks, :hint_id
  end
end
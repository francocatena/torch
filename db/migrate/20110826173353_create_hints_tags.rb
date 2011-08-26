class CreateHintsTags < ActiveRecord::Migration
  def change
    create_table :hints_tags, id: false do |t|
      t.integer :hint_id, null: false
      t.integer :tag_id, null: false
    end
    
    add_index :hints_tags, [:hint_id, :tag_id], unique: true
  end
end
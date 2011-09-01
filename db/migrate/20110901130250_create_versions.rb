class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.references :item, polymorphic: true, null: false
      t.string :event, null: false
      t.integer :whodunnit
      t.text :object
      t.datetime :created_at
    end
    
    add_index :versions, [:item_type, :item_id]
  end
end
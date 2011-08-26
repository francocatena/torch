class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.references :app, null: false

      t.timestamps
    end
    
    add_index :tags, :name
    add_index :tags, :app_id
  end
end
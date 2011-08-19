class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.text :description, null: false
      t.integer :lock_version, default: 0

      t.timestamps
    end
    
    add_index :apps, :name, unique: true
  end
end
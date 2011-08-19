class CreateHints < ActiveRecord::Migration
  def change
    create_table :hints do |t|
      t.string :header, null: false
      t.text :content, null: false
      t.integer :importance, null: false
      t.references :app, null: false
      t.integer :lock_version, default: 0

      t.timestamps
    end
    
    add_index :hints, :header
    add_index :hints, :app_id
  end
end
class AddIndexesToImages < ActiveRecord::Migration
  def change
    add_index :images, :caption
  end
end
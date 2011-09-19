class AddPrivateToHints < ActiveRecord::Migration
  def change
    add_column :hints, :private, :boolean, default: false
  end
end
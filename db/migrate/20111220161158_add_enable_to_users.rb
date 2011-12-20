class AddEnableToUsers < ActiveRecord::Migration
  def change
    add_column :users, :enable, :boolean, default: true
  end
end
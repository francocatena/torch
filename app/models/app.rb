class App < ActiveRecord::Base
  # Restricciones
  validates :name, :url, :presence => true, :uniqueness => true,
    :length => { :maximum => 255 }
  validates :description, :presence => true
end
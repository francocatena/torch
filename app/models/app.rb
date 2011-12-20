class App < ActiveRecord::Base
  # Atributos editables por asignación masiva
  attr_accessible :name, :url, :description, :lock_version
  
  # Restricciones
  validates :name, :url, presence: true, uniqueness: true,
    length: { maximum: 255 }
  validates :description, presence: true
  
  # Relaciones
  has_many :hints, dependent: :destroy, inverse_of: :app
  has_many :tags, dependent: :destroy, inverse_of: :app
  
  def to_s
    self.name
  end
end
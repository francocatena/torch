class Tag < ActiveRecord::Base
  # Restricciones
  validates :app, presence: true
  validates :name, presence: true, uniqueness: { scope: :app_id },
    length: { maximum: 255 }
  
  # Relaciones
  belongs_to :app, inverse_of: :tags
  has_and_belongs_to_many :hints
end
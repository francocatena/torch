class Hint < ActiveRecord::Base
  # Restricciones
  validates :app, :header, :content, :importance, presence: true
  validates :header, uniqueness: { scope: :app_id }, length: { maximum: 255 }
  validates :importance, numericality: { only_integer: true, greater_than: 0 },
    allow_nil: true, allow_blank: true
  
  # Relaciones
  belongs_to :app, inverse_of: :hints
  
  def initialize(attributes = nil, options = {})
    super(attributes, options)
    
    self.importance ||= 1
  end
  
  def to_s
    self.header
  end
end
class Tag < ActiveRecord::Base
  include Comparable
  
  # Atributos editables por asignación masiva
  attr_accessible :app_id, :name
  
  # Scopes
  scope :with_hints, includes(:hints).where(
    [
      "#{Hint.table_name}.id IS NOT NULL",
      "#{Hint.table_name}.private = :false"
    ].join(' AND '), false: false
  )
  
  # Restricciones
  validates :app, presence: true
  validates :name, presence: true, uniqueness: { scope: :app_id },
    length: { maximum: 255 }
  
  # Relaciones
  belongs_to :app, inverse_of: :tags
  has_and_belongs_to_many :hints
  
  def <=>(other)
    self.name <=> other.name
  end
  
  def to_s
    self.name
  end
  
  def as_json(options = nil)
    default_options = { only: [:name] }
    
    super(default_options.merge(options || {}))
  end
end
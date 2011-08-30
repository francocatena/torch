class Feedback < ActiveRecord::Base
  # Callbacks
  before_destroy :avoid_destruction
  
  # Atributos "solo lectura"
  attr_readonly :positive, :hint_id
  
  # Scopes
  scope :positive, where(:positive => true)
  scope :negative, where(:positive => false)
  
  # Relaciones
  belongs_to :hint, inverse_of: :feedbacks
  
  def avoid_destruction
    false
  end
end
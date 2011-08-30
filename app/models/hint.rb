class Hint < ActiveRecord::Base
  # Restricciones
  validates :app, :header, :content, :importance, presence: true
  validates :header, uniqueness: { scope: :app_id }, length: { maximum: 255 }
  validates :importance, numericality: { only_integer: true, greater_than: 0 },
    allow_nil: true, allow_blank: true
  
  # Relaciones
  belongs_to :app, inverse_of: :hints
  has_many :feedbacks, inverse_of: :hint
  has_and_belongs_to_many :tags
  
  def initialize(attributes = nil, options = {})
    super(attributes, options)
    
    self.importance ||= 1
  end
  
  def to_s
    self.header
  end
  
  def tag_list
    self.tags.map(&:to_s).join(',')
  end
  
  def tag_list=(tags)
    tags = (tags || '').split(/\s*,\s*/).reject(&:blank?)
    
    # Remove the removed =)
    self.tags.delete *self.tags.reject { |t| tags.include?(t.name) }
    
    # Add or create and add the new ones
    tags.each do |tag|
      unless self.tags.map(&:name).include?(tag)
        self.tags << self.app.tags.find_or_create_by_name(tag)
      end
    end
  end
end
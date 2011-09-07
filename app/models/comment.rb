class Comment < ActiveRecord::Base
  has_paper_trail
  
  # Callbacks
  after_create :send_by_email
  
  # Atributos "solo lectura"
  attr_readonly :comment, :hint_id
  
  # Atributos no persistentes
  attr_accessor :must_be_sent_by_email
  
  # Restricciones
  validates :comment, :hint, presence: true
  
  # Relaciones
  belongs_to :user
  belongs_to :hint, inverse_of: :comments
  
  def initialize(attributes = nil, options = {})
    super(attributes, options)
    
    self.must_be_sent_by_email = true if self.must_be_sent_by_email.nil?
  end
  
  def creator
    User.find_by_id(self.originator)
  end
  
  def send_by_email
    if self.must_be_sent_by_email == '1' || self.must_be_sent_by_email == true
      Notifications.new_comment(self).deliver
    end
  end
  
  def emails
    self.user ? [self.user.email] : User.all_except(self.originator).map(&:email)
  end
end
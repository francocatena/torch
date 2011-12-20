class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.maintain_sessions = false
    c.crypto_provider = Authlogic::CryptoProviders::Sha512
  end
  
  # Atributos editables por asignación masiva
  attr_accessible :name, :lastname, :email, :password, :password_confirmation,
    :lock_version
  
  # Scopes
  scope :all_except, ->(user_id) { where('id <> ?', user_id) }
  
  # Restricciones
  validates :name, :lastname, presence: true, length: { maximum: 255 }
  validates :name, uniqueness: { scope: :lastname }
  
  def to_s
    [self.name, self.lastname].join(' ')
  end
end
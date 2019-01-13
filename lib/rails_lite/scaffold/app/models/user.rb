require 'bcrypt'

class User < ApplicationModel
  validates :username, presence: true, class: String, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :session_token, presence: true, uniqueness: true

  belongs_to :house,
    optional: true

  has_many :cats,
    foreign_key: :owner_id

  # before_validation :ensure_token
  after_initialize :ensure_token
  
  attr_reader :password
  
  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    user && user.is_password?(password) ? user : nil
  end
  
  def self.generate_token
    SecureRandom::urlsafe_base64
  end
  
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
  
  def ensure_token
    self.session_token ||= User.generate_token
  end
  
  def reset_token!
    self.session_token = User.generate_token
    self.save!
    self.session_token
  end
  
  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
end
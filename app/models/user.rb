class User < ActiveRecord::Base
  attr_accessor :remember_token

  before_save :downcase_email

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 250 },
            format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i },
            uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, allow_blank: true

  has_secure_password

  # self.per_page = 10

  def self.digest(pw)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(pw, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  private
  def downcase_email
    self.email.downcase!
  end
end
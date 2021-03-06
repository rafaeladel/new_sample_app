class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  has_many :microposts, dependent: :destroy

  before_save :downcase_email
  before_create :generate_activation_token

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 250 },
            format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i },
            uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, allow_blank: true

  has_secure_password

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

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end


  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(self.reset_token), reset_sent_at: Time.zone.now)
  end

  def send_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    self.reset_sent_at < 2.hours.ago
  end

  def feed
    Micropost.where("user_id = ?", id)
  end

  private
  def downcase_email
    self.email.downcase!
  end

  def generate_activation_token
    self.activation_token = User.new_token
    self.activation_digest = User.digest(self.activation_token)
  end

end
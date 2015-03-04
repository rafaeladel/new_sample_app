class User < ActiveRecord::Base
  before_save :downcase_email

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 250 },
            format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i },
            uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  has_secure_password

  private
  def downcase_email
    self.email.downcase!
  end
end
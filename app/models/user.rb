class User < ApplicationRecord
  rolify
  after_create :assign_default_role
	enum role: [:user, :admin]
	has_many :articles, dependent: :destroy
	validates :username, presence: true, uniqueness: true, length: { minimum: 3, maxmum: 25 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 30 },
	format: { with: VALID_EMAIL_REGEX }
	before_save { self.email = email.downcase }
	has_secure_password

  def assign_default_role
  	self.add_role :visitor if self.roles.blank?
  end
end


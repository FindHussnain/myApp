class User < ApplicationRecord
	has_many :articles
	validates :username, presence: true, uniqueness: true, length: { minimum: 3, maxmum: 25 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 30 },
	format: { with: VALID_EMAIL_REGEX }
	before_save { self.email = email.downcase }
end
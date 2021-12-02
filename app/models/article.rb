class Article < ApplicationRecord
	belongs_to :user
	validates :title, presence: true, length: {minimum: 5, maxmum: 15}
	validates :description, presence: true, length: {minimum: 5, maximum: 100}
	validates :user_id, presence: true
end

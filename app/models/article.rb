class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :title, presence: true, length: {minimum: 5, maxmum: 100}
  validates :description, presence: true, length: {minimum: 5}
  validates :user_id, presence: true
end

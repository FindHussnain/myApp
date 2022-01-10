class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article
  validates :body, presence: true
  after_commit :create_notifications, on: :create

  private
    def create_notifications
      Notification.create do |notification|
        notification.notify_type = 'article'
        notification.actor = self.user
        notification.user = self.article.user
        notification.target = self
        notification.second_target = self.article
      end
    end
end

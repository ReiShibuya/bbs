class Comment < ApplicationRecord
  belongs_to :topic
  validates :name, presence: true
  validates :content, presence: true
end

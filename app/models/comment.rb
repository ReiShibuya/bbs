class Comment < ApplicationRecord
  belongs_to :topic
  validates :name, presence: true,  length: { minimum: 3 }
  validates :content, presence: true, length: { minimum: 3 }

end

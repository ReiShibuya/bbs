class Comment < ApplicationRecord
  belongs_to :topic
  validates :name, presence: true,  length: { minimum: 3 }
  validates :content, presence: true, length: { minimum: 3 }
  before_validation :set_nameless_nanashi

  private
    def set_nameless_nanashi
      # REVIEW: デフォルトネームを入れる(名無しさん)コードを再確認
      self.name = '名無しさん' if name.blank?
    end

end

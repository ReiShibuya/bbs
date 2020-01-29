class Comment < ApplicationRecord
  belongs_to :topic
  validates :name, presence: true,  length: { minimum: 3 }
  validates :content, presence: true, length: { minimum: 3 }
  validates :reid, presence: true
  before_validation :set_nameless_nanashi

  # 順番付け用メソッド
  def set_reid(id)
    # パブリックメソッドにすればコントローラーでも使えることに気づいた
    # 代入する数字はコントローラー側で渡した方が楽
    # ただ、application_record.rbに定義したほうがいいのだろうか迷う
    # それにパブリックである以上セキュリティホールになるかもしれんので処理だけprivateに定義するべきかも
    set_id(id)
  end

  # 削除用(updateアクション)メソッド
  def delete_comment
    self.name = "削除されました。"
    self.content = "このコメントは削除されました。"
  end

  # デバッグ用
  # def set_name(name)
  #   self.name = name
  # end

  # def set_content(comment)
  #   self.content = comment
  # end

  private
    def set_nameless_nanashi
      # REVIEW: デフォルトネームを入れる(名無しさん)コードを再確認
      self.name = '名無しさん' if name.blank?
    end

    def set_id(id)
      # set_reidの処理
      # 変数がIntegerなら代入すること
      self.reid = id if id.instance_of?(Integer)
    end

    # def set_delete
    #   self.name = "削除されました。"
    #   self.content = "このコメントは削除されました。"
    # end
end

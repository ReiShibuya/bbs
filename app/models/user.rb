class User < ApplicationRecord
  # TODO: 【最優先】管理者ログイン機能を作る前にbcryptをインストール
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end

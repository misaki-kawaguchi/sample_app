class User < ApplicationRecord
  # 保存する前に小文字に変換する（Foo@ExAMPle.Comとfoo@example.comを同一であると解釈する）
  # before_save { self.email = email.downcase }
  before_save { email.downcase! }
  # 名前は入力する（最大50字）
  validates :name, presence: true, length: {maximum: 50 }
  # メールフォーマットを正規表現で検証する
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  # emailは入力する（最大250字）
  validates :email, presence: true, length: { maximum: 250 },
             format: { with: VALID_EMAIL_REGEX },
             #一意性にする（大文字・小文字を無視する）
             uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end

class User < ApplicationRecord
  #remember_tokenを追加
  attr_accessor :remember_token
  # 保存する前に小文字に変換する（Foo@ExAMPle.Comとfoo@example.comを同一であると解釈する）
  # before_save { self.email = email.downcase }
  before_save { email.downcase! }
  # 名前は入力する（最大50字）
  validates :name, presence: true, length: { maximum: 50 }
  # メールフォーマットを正規表現で検証する
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  # emailは入力する（最大250字）
  validates :email, presence: true, length: { maximum: 250 },
             format: { with: VALID_EMAIL_REGEX },
             #一意性にする（大文字・小文字を無視する）
             uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 },  allow_nil: true
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  #ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  #永続セッションのためにユーザーをデータベースに記憶する
  def remember
    #記憶トークンを作成
    self.remember_token = User.new_token
    #User.digestを適用した結果で記憶ダイジェストを更新
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  #渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    #記憶ダイジェストがnilの場合にfalseを返す
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
end

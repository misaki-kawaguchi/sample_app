class User < ApplicationRecord
  #マイクロポストは、その所有者 (ユーザー) と一緒に破棄される
  has_many :microposts, dependent: :destroy
  # 能動的関係に対して1対多 (has_many) の関連付けを実装する（following配列の元はfollowed idの集合である）
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  # 受動的関係を使ってuser.followersを実装する
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  # Userモデルにfollowingの関連付けを追加する
  has_many :following, through: :active_relationships, source: :followed
  # Userモデルにfollowersの関連付けを追加する
  has_many :followers, through: :passive_relationships, source: :follower
  #remember_tokenとactivation_token,reset_tokenを追加
  attr_accessor :remember_token, :activation_token, :reset_token
  # 保存する前に小文字に変換する（Foo@ExAMPle.Comとfoo@example.comを同一であると解釈する）
  # before_save { self.email = email.downcase }
  before_save   :downcase_email
  #作成する前にUserモデルにアカウントを有効化する
  before_create :create_activation_digest
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
  
  #アカウント有効化のダイジェストと渡されたトークンが一致するかチェックする
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # アカウントを有効にする
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest:  User.digest(reset_token), reset_sent_at: Time.zone.now)
  end
  
  # パスワード再設定用のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  # ユーザーのステータスフィードを返す
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
  
  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
  
  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end

class Micropost < ApplicationRecord
  belongs_to :user
  #マイクロポストを順序づける（新しい投稿から順番に並ぶ）
  default_scope -> { order(created_at: :desc) }
  #Micropostモデルに画像を追加する
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size
  
    private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end

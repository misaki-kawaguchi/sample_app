class AddPasswordDigestToUsers < ActiveRecord::Migration[5.1]
  #Userモデルにpassword_digestを追加
  def change
    add_column :users, :password_digest, :string
  end
end

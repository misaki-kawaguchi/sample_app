require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  # 各テストが走る直前に実行
  def setup
    @user = User.new(name: "Exampple User", email: "user@example.com",
                     #has_secure_passwordを追加したら下記の値も追加する
                     password: "foobar", password_confirmation: "foobar")
  end
  
  # Userオブジェクトが有効かテストする
  test "should be valid" do
    assert @user.valid?
  end
  
  #名前は存在するべき（名前が空白なのは有効ではない）
  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end
  
  # emailは存在するべき（emailが空白なのは有効ではない）
  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end
  
  # nameは長くするべきではない（nameが51字なのは有効ではない）
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  # emailは長くするべきではない（emailが244字なのは有効ではない）
  test "email should not be too long" do
    @user.email = "a" * 244 + "example.com"
    assert_not @user.valid?
  end
  
  # 有効なアドレスを受け入れるべきである
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      #どのメールアドレスで失敗したのかテスト
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  # 無効なアドレスは拒否する
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      #どのメールアドレスで失敗したのかテスト
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  # メールアドレスは一意性であるべき（複製されたデータは無効）
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    #メールアドレスを大文字に変換
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  # assert_equa: 値が一致しているかどうか確認する
  # reload:データベースの値に合わせて更新する
  # メールアドレスは小文字で保存されるべき
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  #パスワードは空にしない（空なのは有効ではない）
  test "password should be present(noblank)" do
    @user.password = @user.password_confirmation = "" * 6
    assert_not @user.valid?
  end
  
  # パスワードは最小限の文字数はあるべき（5文字は有効ではない）
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  #ダイジェストが存在しない場合のauthenticated?のテスト
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
end

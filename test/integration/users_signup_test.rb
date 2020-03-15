require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  # 無効なユーザー登録に対するテスト
  test "invalid signup information" do
    get signup_path
    #assert_no_difference (exp [,msg]){block}:渡したブロック実行前後で、式によって評価される結果の数値に変化が無いことを検証
    assert_no_difference 'User.count' do
      post users_path, params: { user: {name: "",
                                 email: "user@invalid",
                                 password: "foo",
                                 password_confirmation: "bar" } }
    end
    assert_template 'users/new'
  end
  
  # 有効なユーザー登録に対するテスト
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: {name: "Example User",
                                 email: "user@example.com",
                                 password: "password",
                                 password_confirmation: "password" } }
    end
    # follow_redirect!:POSTリクエストを送信した結果を見て、指定されたリダイレクト先に移動する
    follow_redirect!
    assert_template 'users/new'
    # flashが空でないかテストする
    assert_not flash.empty?  
  end
end

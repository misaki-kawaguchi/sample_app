require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    # users.ymlより
    @user = users(:michael)
  end
  
  #フラッシュメッセージの残留をキャッチする
  test "login with invalid information" do
    # ログイン用のパスを開く
    get login_path
    # paramsハッシュを使ってセッション用パスにPOSTする
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    # リダイレクト先が正しいかどうかをチェック
    assert_redirected_to @user
    # ページに実際に移動
    follow_redirect!
    # 詳細ページにリダイレクトする
    assert_template 'users/show'
    # ログイン用のリンクが0になる
    assert_select "a[href=?]", login_path, count: 0
    # ログアウトのリンクが出現する
    assert_select "a[href=?]", logout_path
    #ユーザーのプロフィールページにとぶ
    assert_select "a[href=?]", user_path(@user)
  end
  
  # ユーザーログアウトのテスト
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end

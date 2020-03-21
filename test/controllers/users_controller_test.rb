require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  def setup
    @user       = users(:michael)
    @other_user = users(:archer)
  end
  
  #ユーザーのindexページはログインしたユーザーにしか見せないようにする
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  
  #間違ったユーザーが編集しようとしたときトップページにリダイレクトする（edit）
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  #間違ったユーザーが編集しようとしたときトップページにリダイレクトする（update）
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  # admin属性の変更が禁止されていることをテスト
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              @other_user.password,
                                            password_confirmation: @other_user.password,
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end
  
  #管理者権限の制御をアクションレベルでテストする
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
  
  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end

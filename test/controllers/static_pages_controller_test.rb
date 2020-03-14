require 'test_helper'

#StaticPagesコントローラのデフォルトのテスト
class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  #assert_select：特定のHTMLタグが存在するかどうかをテスト
  
  # setup:各テストが実行される直前で実行されるメソッド)
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end
  
  test "should get root" do
    get root_url
    assert_response :success
  end
  
  #Homeページのテスト。
  #GETリクエストをhomeアクションに対して発行せよ。
  #そうすれば、リクエストに対するレスポンスは[成功]になるはず
  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "Home | #{@base_title}"
  end

  #Helpページのテスト。
  #GETリクエストをhelpアクションに対して発行せよ。
  #そうすれば、リクエストに対するレスポンスは[成功]になるはず
  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end
  
  #Aboutページのテスト。
  #GETリクエストをaboutアクションに対して発行せよ。
  #そうすれば、リクエストに対するレスポンスは[成功]になるはず
  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

end

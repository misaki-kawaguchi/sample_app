require 'test_helper'

# StaticPagesコントローラのデフォルトのテスト
class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  # assert_select：特定のHTMLタグが存在するかどうかをテスト
  
  # Homeページのテスト。
  # GETリクエストをhomeアクションに対して発行せよ。
  # そうすれば、リクエストに対するレスポンスは[成功]になるはず
  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "Ruby on Rails Tutorial Sample App"
  end

  # Helpページのテスト。
  # GETリクエストをhelpアクションに対して発行せよ。
  # そうすれば、リクエストに対するレスポンスは[成功]になるはず
  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | Ruby on Rails Tutorial Sample App"
  end
  
  # Aboutページのテスト。
  # GETリクエストをaboutアクションに対して発行せよ。
  # そうすれば、リクエストに対するレスポンスは[成功]になるはず
  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | Ruby on Rails Tutorial Sample App"
  end
  
  # Contactページのテスト。
  # GETリクエストをcontactアクションに対して発行せよ。
  # そうすれば、リクエストに対するレスポンスは[成功]になるはず
  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | Ruby on Rails Tutorial Sample App"
  end

end

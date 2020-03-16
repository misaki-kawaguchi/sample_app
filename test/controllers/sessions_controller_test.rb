require 'test_helper'

# Sessionsコントローラのデフォルトのテスト
class SessionsControllerTest < ActionDispatch::IntegrationTest
  
  # Log inページのテスト。
  # GETリクエストをnewアクションに対して発行せよ。
  # そうすれば、リクエストに対するレスポンスは[成功]になるはず
  test "should get new" do
    get login_path
    assert_response :success
  end

end

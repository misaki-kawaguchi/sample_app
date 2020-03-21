require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない
    # @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  #正常な状態かどうかをテスト
  test "should be valid" do
    assert @micropost.valid?
  end

  #user_idが存在しているかどうか (nilではないか) をテスト
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  #contentが空白なのは有効ではない
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  #contentが141文字なのは有効ではない
  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
  
  #最も新しいマイクロポストを最初に表示する
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
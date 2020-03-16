ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  fixtures :all
  #テスト環境でもapplication_helper.rbを使えるようにする
  include ApplicationHelper
  
  #テストユーザーがログイン中の場合にtrueを返す
  def is_logged_in?
    # nilではない
    !session[:user_id].nil?
  end
end

require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # assert_template:リクエストが適切なテンプレートファイルを使用しているか確認
  # assert_select: selectorに合致した要素の内容を引数equalityでチェック
  
  #リンクが正しく動いているかどうかチェック
  # 1.ルートURL (Homeページ) にGETリクエストを送る.
  # 2.正しいページテンプレートが描画されているかどうか確かめる.
  # 3 Home、Help、About、Contactの各ページへのリンクが正しく動くか確かめる.
  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    #"?"を●●_pathに置換
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get contact_path
    assert_select "title", full_title("Contact")
  end
end

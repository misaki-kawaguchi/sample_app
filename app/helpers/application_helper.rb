module ApplicationHelper
  
  # 新しく作ったメソッド:カスタムヘルパー 
  # カスタムヘルパーの作成
  
  # ページごとの完全なタイトルを返す
  # page_titleが空の場合はbase_titleのみ表示する
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end




  

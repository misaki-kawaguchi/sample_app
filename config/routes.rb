Rails.application.routes.draw do
  
  #トップページ
  root 'static_pages#home'
  
  # home,help,aboutページ
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about'
  
end

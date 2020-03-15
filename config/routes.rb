Rails.application.routes.draw do
  
  get 'users/new'

  # トップページ
  root 'static_pages#home'
  
  # help,about,contactページ
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  
  #ユーザー登録
  get '/signup', to: 'users#new'
end

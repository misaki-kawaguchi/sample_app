Rails.application.routes.draw do

  # トップページ
  root 'static_pages#home'
  
  # help,about,contactページ
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  
  #ユーザー登録
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  resources :users
end

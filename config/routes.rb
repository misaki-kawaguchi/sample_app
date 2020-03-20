Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  # トップページ
  root 'static_pages#home'
  
  # help,about,contactページ(StaticPagesコントローラー)
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  
  #ユーザー登録(Usersコントローラー)
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  
  #ログイン・ログアウト(Sessionsコントローラー)
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users
  
  #アカウント有効化
  resources :account_activations, only: [:edit]
  
  #パスワード再設定
  resources :password_resets, only: [:new, :create, :edit, :update]
end

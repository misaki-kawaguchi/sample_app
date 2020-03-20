class SessionsController < ApplicationController
  
  #ログイン・ログアウト用のコントローラー
  
  # /login(GET)
  def new
  end
  
  # /login(POST)
  def create
    #データベースからユーザーを取り出す（元々小文字で保存している）
    user = User.find_by(email: params[:session][:email].downcase)
    #メールアドレスを持つユーザーがデータベースに存在し、かつ入力されたパスワードがそのユーザーのパスワードである場合
    #（ユーザーがデータベースにあり、かつ、認証に成功した場合にのみ）
    if user && user.authenticate(params[:session][:password])
      #有効でないユーザーがログインすることのないようにする
      if user.activated?
        # sessions_helperに記載
        log_in user
        #チェックボックスの送信結果を処理する
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        #フレンドリーフォワーディング
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # 本当は正しくない
      #レンダリングが終わっているページで特別にフラッシュメッセージを表示することができる（flash.now）
      flash.now[:danger] = 'Invalid email/password combination'
      # ログインページに戻る
      render 'new'
    end
  end
  
  # /logout
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end

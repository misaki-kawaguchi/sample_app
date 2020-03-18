class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  #ユーザー登録用のコントローラー
  
  # /users/
  def index 
    @users = User.paginate(page: params[:page])
  end
  
  # /users/:id [user_path(user)]
  def show
    @user = User.find(params[:id])
  end
  
  # /users/new [new_user_path]
  def new
    @user = User.new
  end
  
  # POST /users [users_path]
  def create
    @user = User.new(user_params)
    if @user.save
      #ユーザー登録した時にログインする
      log_in(@user)
      # 保存に成功するとWelcome to the Sample App!と表示される
      flash[:success] = "Welcome to the Sample App!"
      # 保存に成功すると詳細ページにとぶ[redirect_to user_url(@user)]
      redirect_to @user
    else
      render 'new'
    end
  end
  
  #/users/1/edit [edit_user_path(user)]
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private
  
    #ストロングパラメーター（必須のパラメータと許可されたパラメータを指定）
    # userハッシュに保存
    #例:@user = User.new(name: "Foo Bar", email: "foo@invalid", password: "foo", password_confirmation: "bar")のコードとほぼ同じ
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    #beforeアクション
    #ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
      store_location
      flash[:danger] = "Please log in"
      redirect_to login_url
      end
    end
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
end

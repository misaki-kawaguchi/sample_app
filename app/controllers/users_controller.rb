class UsersController < ApplicationController
  
  # /users/
  def index 
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
      # 保存に成功するとWelcome to the Sample App!と表示される
      flash[:success] = "Welcome to the Sample App!"
      # 保存に成功すると詳細ページにとぶ[redirect_to user_url(@user)]
      redirect_to @user
    else
      render 'new'
    end
  end
  
  private
  
    #ストロングパラメーター（必須のパラメータと許可されたパラメータを指定）
    # userハッシュに保存
    #例:@user = User.new(name: "Foo Bar", email: "foo@invalid", password: "foo", password_confirmation: "bar")のコードとほぼ同じ
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end

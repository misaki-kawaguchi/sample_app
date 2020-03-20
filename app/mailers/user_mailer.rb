class UserMailer < ApplicationMailer

  #アカウント有効化リンクをメールする
  def account_activation(user)
    @user = user
    mail to: user.email, subjest: "Account activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subjest: "Password reset"
  end
end

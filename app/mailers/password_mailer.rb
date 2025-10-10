class PasswordMailer < ApplicationMailer
  def reset
    @token = params[:user].signed_id(purpose: "password_reset", expires_in: 15.minutes)
    @user = params[:user]

    mail to: @user.email, subject: "Reset your password"
  end
end

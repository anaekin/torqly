class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user.present?
      PasswordMailer.with(user: @user).reset.deliver_now
      flash[:info] = "Check your email for the password reset link (may take a few minutes to arrive)."
      redirect_to :create_password
    else
      flash.now[:alert] = "Email not found."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find_signed!(params[:token], purpose: "password_reset")
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to forgot_password_path, alert: "Your password reset link has expired. Please try again."
  end

  def update
    @user = User.find_signed!(params[:token], purpose: "password_reset")
    if @user.update(password_params)
      redirect_to login_path, notice: "Password reset successfully. Please log in."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end

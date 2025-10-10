class ProfilesController < ApplicationController
  before_action :require_login!

  def new
  end

  def edit
  end

  def update
    if Current.user.update(profile_params)
      redirect_to view_profile_path(Current.user), notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def profile_params
    permitted = params.require(:user).permit(:name, :password, :password_confirmation)
    if permitted[:password].blank?
      permitted.delete(:password)
      permitted.delete(:password_confirmation)
    end
    permitted
  end
end

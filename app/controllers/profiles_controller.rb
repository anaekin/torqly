class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def edit
  end

  def update
    if current_user.update(profile_params)
      redirect_to view_profile_path(current_user), notice: "Profile updated successfully."
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

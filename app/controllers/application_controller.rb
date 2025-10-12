class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :is_admin?, :is_logged_in?

  before_action :set_current_user

  def set_current_user
    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def is_admin?
    Current.user&.admin?
  end

  def is_logged_in?
    Current.user.present?
  end

  def require_login!
    unless Current.user
      redirect_to login_path, alert: "You must be logged in to access this section."
    end
  end

  def require_admin!
    unless Current.user&.admin?
      redirect_to root_path, alert: "You must be an admin to access this section."
    end
  end
end

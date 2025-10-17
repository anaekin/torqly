class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :is_admin?, :is_logged_in?
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def is_admin?
    current_user&.admin?
  end

  def is_logged_in?
    current_user.present?
  end

  def require_admin!
    unless is_admin?
      redirect_to root_path, alert: "You must be an admin to access this section."
    end
  end

  private
  def render_not_found
    render file: Rails.root.join("public/404.html"), layout: false, status: :not_found
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end
end

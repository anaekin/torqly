class MainController < ApplicationController
  include ProductAvailability

  def index
    @product_types = ProductType.order(:name)

    return if params[:start_date].blank? && params[:end_date].blank?

    begin
      from = params[:start_date].presence&.to_date
      to = params[:end_date].presence&.to_date
    rescue Date::Error
      flash.now[:alert] = "Invalid dates provided, please try again"
      return
    else
      if !from
        flash.now[:alert] = "Please provide a start date"
        return
      elsif !to
        flash.now[:alert] = "Please provide an end date"
        return
      elsif from < Date.today
        flash.now[:alert] = "Booking start date should be today or later"
        return
      elsif to < from
        flash.now[:alert] = "Booking end date should be after or equal to start date"
        return
      end
    end

    @products = available_products(from, to, params[:product_type]).order(updated_at: :desc)
  end
end

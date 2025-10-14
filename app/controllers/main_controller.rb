class MainController < ApplicationController
  include ProductAvailability

  before_action :load_product_types

  def index
    begin
      from = search_params[:start_date].presence&.to_date || Date.today
      to = search_params[:end_date].presence&.to_date
      product_type = search_params[:product_type] || ""
    rescue Date::Error
      flash.now[:alert] = "Invalid dates provided, please try again"
      return
    else
      if !from
        flash.now[:alert] = "Please select a start date"
        return
      elsif from < Date.today
        flash.now[:alert] = "Booking start date should be today or later"
        return
      elsif to && to < from
        flash.now[:alert] = "Booking end date should be after or equal to start date"
        return
      end
    end

    @products = available_products(from, to, product_type).order(updated_at: :desc)
  end
end

private

def load_product_types
  @product_types = ProductType.order(:name)
end

def search_params
  params.permit(:product_type, :start_date, :end_date)
end

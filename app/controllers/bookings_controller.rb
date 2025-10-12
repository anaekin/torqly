class BookingsController < ApplicationController
  before_action :require_admin!, only: [ :index ]
  before_action :require_login!

  def index
    @bookings = Booking.all
  end

  def new
    @back_path = request.referer || root_path
    if params[:start_date].blank? || params[:end_date].blank? || params[:product_id].blank?
      redirect_to root_path, notice: "Please provide both booking dates and select a product"
    end

    begin
      s = params[:start_date].presence&.to_date
      e = params[:end_date].presence&.to_date
    rescue Date::Error
      flash.now[:alert] = "Invalid dates provided, please try again"
      return
    else
      if !s
        flash.now[:alert] = "Please provide a start date"
        return
      elsif !e
        flash.now[:alert] = "Please provide an end date"
        return
      elsif s < Date.today
        flash.now[:alert] = "Booking start date should be today or later"
        return
      elsif e <= s
        flash.now[:alert] = "Booking end date should be after or equal to start date"
        return
      end
    end

    @booking = Booking.new(user_id: Current.user.id, product_id: params[:product_id], start_date: params[:start_date], end_date: params[:end_date])
    @product = Product.load_details(params[:product_id])
    @start_date = s
    @end_date = e
    @num_days = [ (@end_date - @start_date).to_i, 0 ].max + 1
  end
end

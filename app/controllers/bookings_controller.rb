class BookingsController < ApplicationController
  include DateFiltering, ProductAvailability

  before_action :require_login!
  before_action :set_back_path, only: [ :new, :show ]

  def index
    @bookings = Booking.where(user_id: Current.user.id)&.order(created_at: :desc)
  end

  def new
    dates = parse_dates
    if dates[:error]
      flash.now[:alert] = dates[:error]
      redirect_to root_path, status: :unprocessable_entity and return
    end

    session[:booking_params] = {
      user_id: Current.user.id,
      product_id: params[:product_id],
      start_date: dates[:start_date],
      end_date: dates[:end_date]
    }
    @booking = Booking.new(**session[:booking_params])
  end

  def create
    booking = Booking.new(booking_params.merge(session[:booking_params] || {}))
    session.delete(:booking_params)

    if booking.valid?
      if !is_product_available?(booking.start_date, booking.end_date, booking.product_id)
        redirect_to root_path, alert: "Product is not available for the selected dates. Please try again." and return
      end

      if booking.save
        redirect_to list_bookings_path, notice: "Booking created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to root_path, alert: "Please check your details and try again."
    end
  end

  def show
    @booking = Booking.find(params[:id])
  end

  def destroy
    booking = Booking.find(params[:id])
    if booking.pending? or booking.confirmed?
      booking.update(status: "cancelled")
      redirect_to list_bookings_path, notice: "Booking cancelled successfully."
    else
      flash.now[:alert] = "Only pending and confirmed bookings can be cancelled."
      render :index, status: :unprocessable_entity
    end
  end

  private
  def set_back_path
    @back_path = request.referer || root_path
  end

  def booking_params
    params.require(:booking).permit(:user_id, :product_id, :start_date, :end_date, :license_number, :booked_price)
  end
end

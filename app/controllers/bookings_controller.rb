class BookingsController < ApplicationController
  include DateFiltering, ProductAvailability

  before_action :require_login!
  before_action :set_back_path, only: [ :new, :show ]
  before_action :load_booking, only: [ :show, :destroy ]

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
      product_id: params[:product_id].to_i,
      start_date: dates[:start_date],
      end_date: dates[:end_date]
    }

    @booking = Booking.new(**session[:booking_params])
  end

  def create
    @booking = Booking.new(booking_params.merge(session[:booking_params] || { user_id: Current.user.id }))
    session.delete(:booking_params)

    if !is_product_available?(@booking.start_date, @booking.end_date, @booking.product_id)
      flash.now[:alert] = "Product already booked for the selected dates. Please try again."
      render :new, status: :unprocessable_entity
      return
    end

    if @booking.save
      redirect_to new_payment_path(@booking.id), notice: "Booking successful. Please pay to confirm your booking."
    else
      flash.now[:alert] = @booking.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @back_path = request.referer || root_path
  end

  def destroy
    if !@booking.pending? and !@booking.confirmed?
      redirect_to bookings_path, alert: "Only pending and confirmed bookings can be cancelled."
      return
    elsif @booking.start_date <= Date.today
      redirect_to bookings_path, alert: "Booking cannot be cancelled as it has already started."
      return
    end

    begin
      Booking.transaction do
        @booking.cancel!
      end
      redirect_to bookings_path, notice: "Booking cancelled successfully."
    rescue
      redirect_to bookings_path, alert: @booking.errors.full_messages.to_sentence
    end
  end

  private
  def set_back_path
    @back_path = request.referer || root_path
  end

  def load_booking
    @booking = Booking.find_by!(id: params[:id], user_id: Current.user.id)
  end

  def booking_params
    params.require(:booking).permit(:user_id, :product_id, :start_date, :end_date, :license_number, :booked_price)
  end
end

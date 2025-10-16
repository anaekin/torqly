require "prawn/table"

class BookingsController < ApplicationController
  include DateFiltering, ProductAvailability, ApplicationHelper

  before_action :authenticate_user!
  before_action :set_back_path, only: [ :new, :show ]
  before_action :load_booking, only: [ :show, :destroy ]

  def index
    @bookings = Booking.where(user_id: current_user.id)&.order(created_at: :desc)
  end

  def new
    if new_params[:product_id].nil?
      redirect_to root_path, alert: "Please search and select a product" and return
    end

    dates = parse_dates(new_params[:start_date], new_params[:end_date])
    if dates[:error]
      flash.now[:alert] = dates[:error]
      redirect_to root_path, status: :unprocessable_entity and return
    end

    @product = Product.find(new_params[:product_id].to_i)

    session[:booking_params] = {
      product_id: @product.id,
      start_date: dates[:start_date],
      end_date: dates[:end_date]
    }

    @booking = current_user.bookings.new(
      product: @product, **session[:booking_params]
    )
  end

  def create
    if session[:booking_params].present? && session[:booking_params][:product_id].present?
      redirect_to root_path, alert: "Please search and select a product" and return
    end

    @booking = current_user.bookings.new(
      create_params.merge(session[:booking_params])
    )
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
    @back_path = request.referer || bookings_path
  end

  def destroy
    if !@booking.pending? and !@booking.confirmed?
      redirect_to bookings_path, alert: "Only pending and confirmed bookings can be cancelled."
      return
    elsif @booking.started?
      redirect_to bookings_path, alert: "Booking cannot be cancelled as it has already started."
      return
    end

    begin
      Booking.transaction do
        @booking.cancel!
      end
      redirect_to bookings_path, notice: "Booking cancelled successfully. If you already paid, it will be refunded."
    rescue
      redirect_to bookings_path, alert: @booking.errors.full_messages.to_sentence
    end
  end

  def print
    @booking = Booking.find(params[:id])
    template = render_to_string(partial: "bookings/pdf_header", formats: [ :html ], layout: false)

    send_data Bookings::BookingPdf.new(@booking, template).render,
              filename: "booking_#{@booking.id}.pdf",
              type: "application/pdf",
              disposition: "inline"
  end

  private
  def set_back_path
    @back_path = request.referer || root_path
  end

  def load_booking
    @booking = Booking.find_by!(id: params[:id], user_id: current_user.id)
  end

  def new_params
    params.permit(:product_id, :start_date, :end_date)
  end

  def create_params
    params.require(:booking).permit(:license_number)
  end
end

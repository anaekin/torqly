class PaymentsController < ApplicationController
  before_action :set_booking, only: %i[ new create ]
  before_action :require_login!

  def new
    if @booking.nil?
      redirect_to list_bookings_path, alert: "You are not authorized to create a payment for this booking."
    else
      @payment = Payment.new(booking_id: params[:id], amount: @booking.booked_price * @booking.num_days)
    end
  end


  def create
    payment = Payment.new(payment_params.merge(booking_id: @booking.id, amount: @booking.booked_price * @booking.num_days))

    if payment.save
      Payment.transaction do
        payment.update(status: "succeeded")
        @booking.update(status: "confirmed")
      end
      redirect_to list_bookings_path, notice: "Payment successful. Your booking has been confirmed."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find_by(id: params[:id], user_id: Current.user.id)
    end

    def payment_params
      params.require(:payment).permit(:payment_type, :payment_ref, :provider)
    end
end

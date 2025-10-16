class PaymentsController < ApplicationController
  before_action :load_booking, only: %i[ new create ]
  before_action :require_login!

  def new
    @back_path = request.referer || root_path
    if @booking.nil?
      redirect_to bookings_path, alert: "You are not authorized to create a payment for this booking."
    else
      @payment = Payment.new(booking_id: params[:id], amount: @booking.booked_price * @booking.num_days)
    end
  end


  def create
    @payment = Payment.new(payment_params.merge(booking_id: @booking.id, amount: @booking.booked_price * @booking.num_days))

    begin
      Payment.transaction do
        @payment.save!

        # We can add some other logic, so like temporary saving the payment as pending
        # For now, we confirm the booking and payment
        @booking.confirm!(@payment)
      end
      redirect_to bookings_path, notice: "Payment successful. Your booking has been confirmed."
    rescue => e
      flash.now[:alert] = e.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  private
    def load_booking
      @booking = Booking.find_by(id: params[:id], user_id: Current.user.id)
    end

    def payment_params
      params.require(:payment).permit(:payment_type, :payment_ref, :provider)
    end
end

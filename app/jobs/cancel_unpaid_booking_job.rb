class CancelUnpaidBookingJob < ApplicationJob
  queue_as :default

  def perform(booking_id)
    booking = Booking.find_by(id: booking_id)
    return unless booking

    if booking.pending? && booking.created_at <= 1.hour.ago
      booking.cancel!
    end
  end
end

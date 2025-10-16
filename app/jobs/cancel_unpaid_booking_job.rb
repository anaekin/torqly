class CancelUnpaidBookingJob < ApplicationJob
  queue_as :default

  def self.add_job(booking_id)
    set(wait: 2.minute).perform_later(booking_id)
  end

  def perform(booking_id)
    booking = Booking.find_by(id: booking_id)
    return unless booking&.pending?

    booking.cancel!
  end
end

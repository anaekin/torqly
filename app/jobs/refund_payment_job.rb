class RefundPaymentJob < ApplicationJob
  queue_as :default

  def perform(payment_id)
    payment = Payment.find_by(id: payment_id)
    return unless payment&.succeeded?

    payment.refund!
  end
end

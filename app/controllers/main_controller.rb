class MainController < ApplicationController
  def index
    @product_types = ProductType.order(:name)

    return if params[:start_date].blank? && params[:end_date].blank?

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

    @products = available_products(s, e, params[:product_type]).order(updated_at: :desc)
  end

  private

  def available_products(s, e, slug)
    scope = Product.where(enabled: true).includes(:product_type)
    scope = scope.where(product_type: ProductType.where(slug: slug)) if slug.present? && ProductType::SLUGS.value?(slug)
    return scope if s.blank? || e.blank?

    booked_ids = Booking.where(start_date: ..e).where(end_date: s..).distinct.pluck(:product_id)

    scope.where.not(id: booked_ids)
  end
end

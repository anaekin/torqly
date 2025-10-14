module ProductAvailability
  extend ActiveSupport::Concern

  def get_overlapping_products(from, to = nil)
    if to.nil?
      Booking.where.not(status: :cancelled).where.not(end_date: ...from).pluck(:product_id).uniq
    else
      Booking.where.not(status: :cancelled).where(start_date: ..to, end_date: from..).pluck(:product_id).uniq
    end
  end

  def available_products(from, to = nil, slug)
    scope = Product.where(enabled: true).includes(:product_type)
    scope = scope.where(product_type: ProductType.where(slug: slug)) if slug && ProductType::SLUGS.value?(slug)

    # check for products that overlap with search dates
    # Requested: [20————25] [from...to]
    # [start_date...end_date]
    # [10—15] ❌ (ends before 20)
    # [26—30] ❌ (starts after 25)
    # [18——22] ✅ (overlaps)
    overlap_product_ids = get_overlapping_products(from, to)

    # return products that don't overlap
    scope.where.not(id: overlap_product_ids)
  end

  def is_product_available?(from, to, product_id)
    # check for products that overlap with booking dates
    overlap_product_ids = get_overlapping_products(from, to)

    # return false if product_id is in overlap product_ids
    !overlap_product_ids.include?(product_id)
  end
end

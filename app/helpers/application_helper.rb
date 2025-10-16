module ApplicationHelper
  include ActionView::Helpers::NumberHelper

  def eur(amount, with_symbol: true)
    unit = with_symbol ? "€" : "EUR"
    number_to_currency(amount, unit: unit, separator: ",", delimiter: ".", format: "%u%n")
  end
end

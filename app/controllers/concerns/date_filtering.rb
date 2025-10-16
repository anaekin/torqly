module DateFiltering
  extend ActiveSupport::Concern

  def parse_dates(from, to)
    begin
      start_date = from.presence&.to_date
      end_date = to.presence&.to_date
      { start_date: start_date, end_date: end_date, error: nil }
    rescue Date::Error
      { start_date: nil, end_date: nil, error: "Invalid dates provided, please try again" }
    end
  end
end

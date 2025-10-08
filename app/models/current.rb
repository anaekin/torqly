class Current < ActiveSupport::CurrentAttributes
  attribute :user

  # resets the attributes for each request
  resets { Time.zone = nil }
end

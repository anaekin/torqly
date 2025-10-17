require 'rails_helper'

RSpec.describe "Main#index", type: :request do
  it "renders the index page" do
    get root_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Motorcycle")
  end

  it "filters by slug" do
    get root_path, params: { product_type: "motorcycle", start_date: Date.today.to_s }
    expect(response).to have_http_status(:ok)
  end
end

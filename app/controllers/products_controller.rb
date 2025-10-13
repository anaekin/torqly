class ProductsController < ApplicationController
  before_action :require_admin!, only: [ :new, :create, :edit, :destroy ]
  before_action :load_product_types, only: [ :new, :create, :edit, :destroy ]
  before_action :find_product, except: [ :index, :new, :create ]

  def index
    @products = Product.includes(:product_type, :description).order(updated_at: :desc)
  end

  def new
    @product = Product.new(enabled: true, product_type_id: @product_types.first&.id)
  end

  def show
    @back_path = request.referer || root_path
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_path, notice: "Product created successfully."
    else
      @product_types = ProductType.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "Product updated successfully."
    else
      @product_types = ProductType.all
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    if @product.bookings.any?
      redirect_to products_path, alert: "Product has bookings and cannot be deleted."
    end

    @product.destroy
    redirect_to products_path, notice: "Product deleted successfully."
  end

  private
  def find_product
    @product = Product.find(params[:id])
  end

  def load_product_types
    @product_types = ProductType.order(:name)
  end

  def product_params
    params.require(:product).permit(
      :title, :summary, :price, :brand, :model, :year,
      :image, :enabled, :product_type_id,
      description_attributes: [ :id, :seats, :transmission, :car_type,
                              :engine_cc, :engine_hp, :engine_nm,
                              :range_km, :helmet_included, :seat_storage ]
    )
  end
end

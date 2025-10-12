class ProductsController < ApplicationController
  before_action :require_login!
  before_action :load_product_types, only: [ :new, :create, :edit, :update ]

  def index
    @products = Product.includes(:product_type).order(updated_at: :desc)
  end

  def new
    @product = Product.new(enabled: true)
    @product.build_car_description
    @product.build_motorcycle_description
    @product.build_scooter_description
  end

  def show
    @product = Product
    .includes(:product_type, :car_description, :motorcycle_description, :scooter_description)
    .find(params[:id])
  end

  def create
    @product = Product.new(product_params)
    @product.product_type_id ||= @product_types.first&.id

    build_vehicle_description(@product)

    if @product.save
      redirect_to products_path, notice: "Product created successfully."
    else
      @product_types = ProductType.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product = Product
    .includes(:product_type, :car_description, :motorcycle_description, :scooter_description)
    .find(params[:id])
  end

  def update
    @product = Product
    .includes(:product_type, :car_description, :motorcycle_description, :scooter_description)
    .find(params[:id])

    if @product.update(product_params)
      redirect_to products_path, notice: "Product updated successfully."
    else
      @product_types = ProductType.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path, notice: "Product deleted successfully."
  end

  private
  def load_product_types
    @product_types = ProductType.order(:name)
  end

  def product_params
    chosen_type_id = params.dig(:product, :product_type_id)
    slug = ProductType.where(id: chosen_type_id).pick(:slug)

    base = [
      :title, :summary, :price, :brand, :model, :year,
      :image, :enabled, :product_type_id
    ]

    nested =
      case slug
      when ProductType.car_slug
        { car_description_attributes:        [ :id, :seats, :transmission, :car_type ] }
      when ProductType.motorcycle_slug
        { motorcycle_description_attributes: [ :id, :engine_cc, :engine_nm, :engine_hp ] }
      when ProductType.scooter_slug
        { scooter_description_attributes:    [ :id, :range_km, :helmet_included, :seat_storage ] }
      else
        nil
      end
    params.require(:product).permit(*base, **nested)
  end

  def build_vehicle_description(product)
    if product.car? then product.build_car_description unless product.car_description
    elsif product.motorcycle? then product.build_motorcycle_description unless product.motorcycle_description
    elsif product.scooter? then product.build_scooter_description unless product.scooter_description
    end
  end
end

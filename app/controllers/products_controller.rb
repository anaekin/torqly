class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :edit, :destroy ]
  before_action :load_product_types, only: [ :new, :create, :edit, :destroy ]
  before_action :load_product, only: [ :show, :edit, :update, :destroy ]

  def index
    @products = Product.includes(:product_type, :description).order(updated_at: :desc)
  end

  def new
    @product = Product.new(enabled: true, product_type_id: @product_types.first&.id)
    @product.build_description unless @product.description
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_path, notice: "Product created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @back_path = request.referer || root_path
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "Product updated successfully."
    else
      flash.now[:alert] = @product.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      redirect_to products_path, notice: "Product deleted successfully."
    else
      redirect_to products_path, alert: @product.errors.full_messages.to_sentence
    end
  end

  private
  def load_product
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

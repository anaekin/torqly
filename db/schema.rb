# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_10_13_132656) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "product_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.decimal "booked_price", precision: 10, scale: 2, null: false
    t.string "license_number", null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "num_days", null: false
    t.index ["product_id"], name: "index_bookings_on_product_id"
    t.index ["start_date", "end_date"], name: "index_bookings_on_start_date_and_end_date"
    t.index ["user_id"], name: "index_bookings_on_user_id"
    t.check_constraint "end_date >= start_date", name: "bookings_valid_range"
    t.check_constraint "status::text = ANY (ARRAY['pending'::character varying, 'confirmed'::character varying, 'cancelled'::character varying, 'completed'::character varying]::text[])", name: "bookings_status_check"
  end

  create_table "descriptions", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "product_type_id", null: false
    t.string "type", null: false
    t.integer "seats", default: 4
    t.string "transmission", default: "manual"
    t.string "car_type", default: "petrol"
    t.integer "engine_cc"
    t.integer "engine_hp"
    t.integer "engine_nm"
    t.integer "range_km"
    t.boolean "helmet_included"
    t.integer "seat_storage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_descriptions_on_product_id"
    t.index ["product_type_id"], name: "index_descriptions_on_product_type_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.integer "amount", null: false
    t.string "payment_type", default: "card", null: false
    t.string "status", default: "pending", null: false
    t.string "provider"
    t.string "payment_ref"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_payments_on_booking_id"
    t.index ["payment_type"], name: "index_payments_on_payment_type"
    t.index ["status"], name: "index_payments_on_status"
    t.check_constraint "payment_type::text = ANY (ARRAY['card'::character varying, 'bank_transfer'::character varying, 'cash'::character varying, 'other'::character varying]::text[])", name: "payments_payment_type_check"
    t.check_constraint "status::text = ANY (ARRAY['pending'::character varying, 'succeeded'::character varying, 'failed'::character varying, 'refunded'::character varying]::text[])", name: "payments_status_check"
  end

  create_table "product_types", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_product_types_on_slug", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.bigint "product_type_id", null: false
    t.string "title", null: false
    t.text "summary", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.string "brand", null: false
    t.string "model", null: false
    t.integer "year", null: false
    t.string "image_url"
    t.boolean "enabled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_type_id"], name: "index_products_on_product_type_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookings", "products"
  add_foreign_key "bookings", "users"
  add_foreign_key "descriptions", "product_types"
  add_foreign_key "descriptions", "products"
  add_foreign_key "payments", "bookings"
  add_foreign_key "products", "product_types"
end

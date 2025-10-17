# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb
# This file should ensure the existence of records required to run the application in every environment.

# db/seeds.rb
require "open-uri"

puts "Clearing old data..."
Payment.destroy_all
Booking.destroy_all
Description.destroy_all
Product.destroy_all
ProductType.destroy_all
User.destroy_all

User.create!(
  name: "Animesh Jain",
  email: "animesh.jain1203@gmail.com",
  password: "password123",
  password_confirmation: "password123",
  admin: true
)
puts "✅ Seed user created: animesh.jain1203@gmail.com / password123"

puts "Creating product types..."
car_type       = ProductType.create!(name: "Car",        slug: "car")
scooter_type   = ProductType.create!(name: "Scooter",    slug: "scooter")
motorcyle_type = ProductType.create!(name: "Motorcycle", slug: "motorcycle")

puts "Creating products..."

# ----- Car -----
product = Product.new(
  product_type: car_type,
  title: "Tesla Model 3",
  summary: "Electric car with autopilot",
  brand: "Tesla",
  model: "Model 3",
  year: 2024,
  price: 120.0,
  enabled: true
)
# build the STI description before save
product.build_description(
  product_type: car_type,
  seats: 5,
  transmission: "automatic",
  car_type: "electric"
)
product.save!

file = File.open(Rails.root.join("db/seed_images/car.png"))
product.image.attach(io: file, filename: "car.png", content_type: "image/png")

# ----- Scooter -----
product2 = Product.new(
  product_type: scooter_type,
  title: "Vespa Primavera",
  summary: "Orange scooter to take you anywhere",
  brand: "Vespa",
  model: "Primavera",
  year: 2020,
  price: 35.0,
  enabled: true
)
product2.build_description(
  product_type: scooter_type,
  range_km: 30,
  helmet_included: true,
  seat_storage: 1
)
product2.save!

file2 = File.open(Rails.root.join("db/seed_images/scooter.png"))
product2.image.attach(io: file2, filename: "scooter.png", content_type: "image/png")

# ----- Motorcycle -----
product3 = Product.new(
  product_type: motorcyle_type,
  title: "Honda CBR1000R",
  summary: "Fast bike with great brakes",
  brand: "Honda",
  model: "CBR",
  year: 2023,
  price: 50.0,
  enabled: true
)
product3.build_description(
  product_type: motorcyle_type,
  engine_cc: 1000,
  engine_hp: 214,
  engine_nm: 113
)
product3.save!

file3 = File.open(Rails.root.join("db/seed_images/motorcycle.png"))
product3.image.attach(io: file3, filename: "motorcycle.png", content_type: "image/png")

puts "✅ Seeding complete!"

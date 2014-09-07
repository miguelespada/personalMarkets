# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def create_some_users
  (1..5).each do |index|
    user = User.new(email: "user#{index}@pm.com", password: "12345678")
    user.save!
  end
end

def create_admin_user
  admin = User.new(email: "admin@pm.com", password: "12345678")
  admin.save!
  admin.update_role :admin
end

def create_markets
  user = User.create!(email: "user@pm.com", password: "12345678")

  10.times do |n|
    name = Faker::Company.name
    description = Faker::Commerce.product_name
    category = Category.create!(name: "category#{n}")
    longitude = Faker::Address.longitude
    latitude = Faker::Address.latitude

    Market.create!(
      name: name,
      description: description,
      user: user,
      category: category,
      longitude: longitude,
      latitude: latitude
      )

  end
  10.times do |n|
    name = Faker::Company.name
    description = Faker::Commerce.product_name
    category = Category.where(name: "category#{n}").first
    longitude = Faker::Address.longitude
    latitude = Faker::Address.latitude

    Market.create!(
      name: name,
      description: description,
      user: user,
      category: category,
      longitude: longitude,
      latitude: latitude,
      state: "published"
      )

  end
end

create_some_users
create_admin_user
create_markets

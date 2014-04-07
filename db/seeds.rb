# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def create_moderator_user
  moderator = User.new(email: "moderator@pm.com", password: "12345678")
  moderator.add_role :moderator
  moderator.save!
end

def create_admin_user
  admin = User.new(email: "admin@pm.com", password: "12345678")
  admin.add_role :admin
  admin.save!
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
end

create_moderator_user
create_admin_user
create_markets

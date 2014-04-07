# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def create_moderator
  moderator = User.new(email: "moderator@pm.com", password: "12345678")
  moderator.add_role :moderator
  moderator.save!
end

def create_admin
  admin = User.new(email: "admin@pm.com", password: "12345678")
  admin.add_role :admin
  admin.save!
end

User.create!(email: "user@pm.com", password: "12345678")
create_moderator
create_admin

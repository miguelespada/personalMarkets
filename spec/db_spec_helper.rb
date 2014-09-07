require 'mongoid'
require 'capybara'
require 'rspec'
require 'factory_girl'

ENV["RAILS_ENV"] ||= 'test'
ENV["MONGOID_ENV"] = 'test'

Mongoid.load! "config/mongoid.yml"
Mongoid.configure do |config|
  config.logger = nil
end

RSpec.configure do |config|

  config.color_enabled = true
  config.formatter = :documentation
  config.include Capybara::DSL, :type => :request
  config.include FactoryGirl::Syntax::Methods

  config.before(:each) do
    Mongoid::IdentityMap.clear
  end
end
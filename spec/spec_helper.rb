# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
# require 'rspec/autorun'


# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
# ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

Capybara.run_server = true
Capybara.javascript_driver = :webkit


RSpec.configure do |config|
  config.reset
  config.output_stream = $stdout

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  #config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  config.color_enabled = true
  config.formatter = :documentation
  config.include Capybara::DSL, :type => :request
  config.include FactoryGirl::Syntax::Methods

  # Clean up the database
  require 'database_cleaner'

  config.before(:suite) do
    Market.delete_index
    User.delete_index 
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
  end

  config.before(:each) do
    Keen.stub(:publish_async) { }
    Market.create_index
    DatabaseCleaner.clean
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Market.delete_index
  end

  config.after(:all) do
    DatabaseCleaner.clean
    Market.delete_index 
    User.delete_index 
  end
end

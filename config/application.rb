require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module PopUpStores
  class Application < Rails::Application

    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end
    
    config.generators do |g|
      g.view_specs false
      g.helper_specs false
    end

    Mongoid.logger.level = Logger::ERROR
    Moped.logger.level = Logger::ERROR  
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]

    if Rails.env.test?
      config.i18n.default_locale = :en
    else
      config.i18n.default_locale = :es
    end
    
    config.i18n.enforce_available_locales = false

    social_keys = File.join(Rails.root, 'config', 'social_keys.yml')

    CONFIG = HashWithIndifferentAccess.new(YAML::load(IO.read(social_keys)))[Rails.env]
    CONFIG.each do |k,v|
      ENV[k.upcase] ||= v
    end

    prices = File.join(Rails.root, 'config', 'prices.yml')
    PRICES_CONFIG = HashWithIndifferentAccess.new(YAML::load(IO.read(prices)))
    PRICES_CONFIG.each do |k,v|
      ENV[k.upcase] ||= v
    end
  end
  
  require "attachinary/orm/mongoid"

end

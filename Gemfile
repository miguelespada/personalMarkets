source 'https://rubygems.org'

ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'
gem "devise"
gem "bson_ext"
gem "mongoid", ">= 2.0.0.beta.19"
gem "rails_12factor", group: :production

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use bootstrap with SASS for the layout
gem 'bootstrap-sass'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Photo management
gem 'cloudinary'
gem 'attachinary', git: 'git://github.com/rochers/attachinary.git', branch: 'rails4'

# forms
gem 'simple_form'

#tags
gem 'mongoid_taggable'
gem "tagmanager-rails", "~> 3.0.1.0"


# search
gem "tire", "~> 0.6.2"

# google maps
gem 'gmaps4rails'


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

group :test do
  gem "database_cleaner"
  gem "mongoid-rspec"
  gem "cucumber-rails", require: false
  gem "capybara"
  gem 'capybara-webkit'
  gem "launchy"
  gem "factory_girl_rails"
  gem 'jasmine-rails'
  gem 'pry'
end

group :test, :development do
  gem "rspec-rails"
end
gem "font-awesome-rails"

gem 'draper', '~> 1.3'



source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# App
gem "rails", "~> 5.1.0.rc2"
gem "puma", "~> 3.9"
gem "pg", "~> 0.18"

# Models
gem "pg_search", "~> 2.0.1"
gem "schema_validations", "~> 2.2.1"
gem "enumerize", "~> 2.1.2"
gem "audited", "~> 4.5.0"
gem "easy_postgis"
gem "activejob-perform_later", "~> 1.0.2"

# Assets
gem "sass-rails", github: "rails/sass-rails"
gem "uglifier", "~> 3.2.0"
gem "turbolinks", "~> 5"
gem "bootstrap-sass", "~> 3.3.7"
gem "font-awesome-rails", "~> 4.7.0"
gem "jquery-rails", "~> 4.3.1"
gem "jquery-datatables"
gem "chartkick"

# Authentication & Authorization
gem "devise"
gem "devise_invitable"
gem "pundit"

# Views
gem "slim-rails", "~> 3.1.2"
gem "simple_form", "~> 3.5.0"
gem "cocoon", "~> 1.2.10"
gem "jbuilder", "~> 2.5"

# General purpose
gem "avatax"
gem "taxjar-ruby", require: "taxjar"
gem "kaminari", "~> 1.0.1"
gem "therubyracer", platforms: :ruby
gem "coderay", "~> 1.1.1"
gem "redcarpet", "~> 3.4.0"
gem "wicked_pdf", "~> 1.1.0"
gem "wkhtmltopdf-binary", "~> 0.12.3.1"
gem "wicked"
gem "hashids"

# Services
gem "rollbar"

# Images
gem "carrierwave", "~> 1.0.0"
gem "shrine", "~> 2.6.1"
gem "image_processing", "~> 0.4.1"
gem "fastimage", "~> 2.1.0" # TODO: Do we use this gem?
gem "mini_magick", "~> 4.7.0"

# Payments
gem "stripe"

# Currency
gem "money-open-exchange-rates"

# Jobs
gem "whenever", require: false

# Marketing
gem "hubspot-ruby"

# Emails
gem "smtpapi"
gem "listen"

# Profiling
gem "rack-mini-profiler", "~> 0.10.2"
gem "flamegraph", "~> 0.9.5"
gem "stackprof", "~> 0.2.10"
gem "bullet", "~> 5.5.1" # TODO: Remove bullet from production

# States and provinces
gem "city-state"

group :development do
  gem "annotate"
  gem "binding_of_caller"
  gem "rubocop"
  gem "capistrano", "~> 3.8.1"
  gem "capistrano-rails", "~> 1.2.3"
  gem "capistrano-passenger"
  gem "rails-erd"
end

group :development, :test do
  gem "factory_bot_rails"
  gem "faker"
  gem "pry-byebug"
  gem "rspec-rails"
end

group :dev, :development do
  gem "better_errors"
end

group :test do
  gem "capybara"
  gem "cucumber-rails", require: false
  gem "database_cleaner"
  gem "rails-controller-testing"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "simplecov"
  gem "timecop"
  gem "vcr"
  gem "webmock"
  gem "cucumber"
  gem "rspec_junit_formatter"
  gem "launchy"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

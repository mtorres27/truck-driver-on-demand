source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "~> 5.1.0.rc1"

gem "pg", "~> 0.18"

gem "puma", "~> 3.7"

gem "slim-rails", ">= 3.1.2"

gem "sass-rails", github: "rails/sass-rails"
gem "uglifier", ">= 1.3.0"
gem "turbolinks", "~> 5"

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem "therubyracer", platforms: :ruby

gem "jbuilder", "~> 2.5"

gem "omniauth", ">= 1.6.1"
gem "omniauth-facebook", ">= 4.0.0"
gem "omniauth-google-oauth2", ">= 0.4.1"
gem "omniauth-linkedin-oauth2", ">= 0.2.5", git: "https://github.com/pairshaped/omniauth-linkedin-oauth2.git"

gem "activejob-perform_later", ">= 1.0.2"

# Use ActiveModel has_secure_password
# gem "bcrypt", "~> 3.1.7"

# group :production, :staging do
#   gem "redis", "~> 3.0"
# end

group :development, :test do
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]

  gem "capybara", "~> 2.13.0"
  gem "selenium-webdriver"

  gem "annotate", ">= 2.6.5"

  gem "factory_girl_rails", ">= 4.8.0"
  gem "faker", ">= 1.7.3"
  gem "mocha", ">= 1.2.1"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "web-console", ">= 3.3.0"

  gem "listen", ">= 3.0.5", "< 3.2"

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"

  gem "capistrano-rails", "~> 1.2", group: :development

  gem "rubocop", ">= 0.48", require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

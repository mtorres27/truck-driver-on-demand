require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Avjunction
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = "Eastern Time (US & Canada)"

    config.active_record.schema_format = :sql

    config.middleware.use WickedPdf::Middleware, {}, only: %r[/payments\/.*\/print]

    config.sass.preferred_syntax = :sass

    # Authication providers
    config.middleware.use OmniAuth::Builder do
      provider(
        :google_oauth2,
        Rails.application.secrets.auth_google_client_id,
        Rails.application.secrets.auth_google_secret
      )

      provider(
        :facebook,
        Rails.application.secrets.auth_facebook_client_id,
        Rails.application.secrets.auth_facebook_secret
      )

      provider(
        :linkedin,
        Rails.application.secrets.auth_linkedin_client_id,
        Rails.application.secrets.auth_linkedin_secret
      )
    end
  end
end

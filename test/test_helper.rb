require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "mocha/mini_test"

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  # TODO doesn't seem to work yet
  # OmniAuth.config.test_mode = true
  # OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
  #   provider: "google_oauth2",
  #   uid: '123545'
  # })
end

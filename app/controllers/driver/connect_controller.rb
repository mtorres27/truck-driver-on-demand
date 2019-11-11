# frozen_string_literal: true

class Driver::ConnectController < Driver::BaseController

  def connect
    authorize current_user
    country_spec = Stripe::CountrySpec.retrieve("US")
    logger.debug country_spec
  end

end

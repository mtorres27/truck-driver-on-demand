class Freelancer::ConnectController < Freelancer::BaseController
  def connect
    country_spec = Stripe::CountrySpec.retrieve("US")
    logger.debug country_spec
  end
end
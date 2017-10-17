class Freelancer::BankingController < Freelancer::BaseController
  def index
    @country_spec = Stripe::CountrySpec.retrieve("ca")
    logger.debug @country_spec
    logger.debug current_freelancer.inspect
  end

  def connect

  end
end

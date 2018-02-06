class Freelancer::MainController < Freelancer::BaseController
  def index
    @companies =  Company.where(:disabled => false).order(id: 'DESC').limit(4)
    logger.debug @companies.inspect
  end
end
  
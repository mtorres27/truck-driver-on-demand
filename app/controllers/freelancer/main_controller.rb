class Freelancer::MainController < Freelancer::BaseController
  def index
    # @companies =  Company.where(:disabled => false).order(id: 'DESC').limit(4)
    # @companies = Company.find([67, 13, 64, 59]);
    @companies ||= []
    begin
      @companies = Company.find([67, 13, 64, 59]);
    rescue Exception

    end
  end
end

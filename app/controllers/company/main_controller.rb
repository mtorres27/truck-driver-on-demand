class Company::MainController < Company::BaseController

  def index
    # @freelancers = Freelancer.where(disabled: false).order(id: 'DESC').limit(4)
    @freelancers ||= []
    begin
      @freelancers = Freelancer.find([335, 229, 320, 393]);
    rescue Exception

    end
  end

end

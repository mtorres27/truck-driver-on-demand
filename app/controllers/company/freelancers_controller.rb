class Company::FreelancersController < Company::BaseController

  def index
    @keywords = params.dig(:search, :keywords).presence
    @address = params.dig(:search, :address).presence

    @freelancers = Freelancer.order(:name)
    if @address
      # TODO, turn into lat / lng
    end

    if @keywords
      @freelancers = @freelancers.search(@keywords)
    end

    @freelancers = @freelancers.page(params[:page]).per(5)
  end

  def show
    Freelancer.find(params[:id])
  end

end

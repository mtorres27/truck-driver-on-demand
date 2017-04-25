class Admin::FreelancersController < Admin::BaseController
  before_action :set_freelancer, only: [:show, :edit, :update, :destroy, :enable, :disable, :login_as]

  def index
    @freelancers = Freelancer.order(:name).page params[:page]

    # TODO - search
    # search = params[:search]
    #
    # @freelancers = apply_search(
    #   Freelancer.order(:disabled, :name),
    #   search ? search[:q] : nil
    # ).page(params[:page] || 1).per(20)
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @freelancer.update(company_params)
        format.html { redirect_to admin_freelancer_path(@freelancer), notice: "Freelancer updated." }
        format.json { render :show, status: :ok, location: @freelancer }
      else
        format.html { render :edit }
        format.json { render json: @freelancer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @freelancer.destroy

    respond_to do |format|
      format.html { redirect_to admin_freelancers_path, notice: "Freelancer removed." }
      format.json { head :no_content }
    end
  end

  def enable
    @freelancer.enable!

    respond_to do |format|
      format.html { redirect_to admin_freelancers_path, notice: "Freelancer enabled." }
      format.json { head :no_content }
    end
  end

  def disable
    @freelancer.disable!

    respond_to do |format|
      format.html { redirect_to admin_freelancers_path, notice: "Freelancer disabled." }
      format.json { head :no_content }
    end
  end

  def login_as
    session[:freelancer_id] = @freelancer.id
    redirect_to freelancer_root_path, notice: "You have been logged in as #{@freelancer.name}"
  end


  private

    def set_freelancer
      @freelancer = Freelancer.find(params[:id])
    end

    def freelancer_params
      params.fetch(:freelancer, {})
    end

end

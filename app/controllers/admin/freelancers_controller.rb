# frozen_string_literal: true
class Admin::FreelancersController < Admin::BaseController
  before_action :load_freelancer, only: [:show, :edit, :update, :destroy, :sign_in_as]

  def index
    @freelancers = Freelancer.order(:name)

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
    if @freelancer.update_attributes(freelancer_params)
      redirect_to admin_freelancers_path, notice: "#{@freelancer.name} was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @freelancer.destroy
    redirect_to admin_freelancers_path, notice: "#{@freelancer.name} was successfully removed."
  end

  # TODO - sign in as
  def sign_in_as
    # authorize @freelancer, :sign_in_as?
    # sign_in(:freelancer, @freelancer)
    # redirect_to members_path, notice: "You have been signed in as #{@freelancer.email}"
  end


  private

  def load_freelancer
    @freelancer = Freelancer.find(params[:id])
  end

end

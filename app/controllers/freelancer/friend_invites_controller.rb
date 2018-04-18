class Freelancer::FriendInvitesController < Freelancer::BaseController
  def show
    @friend_invites = current_freelancer.friend_invites
    @avj_credit = current_freelancer.avj_credit || 0
  end

  def update
    @freelancer = current_freelancer

    if @freelancer.update(friend_invites_params)
      FreelancerMailer.notice_invites_sent(@freelancer).deliver
      redirect_to freelancer_friend_invites_path
    else
      flash[:error] = "An error occurred. #{@freelancer.errors.full_messages}"
      render :show
    end
  end

  private
  def friend_invites_params
    params.require(:freelancer).permit(
        friend_invites_attributes: [:email, :name]
    )
  end
end
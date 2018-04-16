class Freelancer::FriendInvitesController < Freelancer::BaseController
  def index
    @friend_invites = current_freelancer.friend_invites
    @avj_credit = current_freelancer.avj_credit || 0
  end

  def create
    # Check this shit
    @freelancer = current_freelancer

    if @freelancer.udate(friend_invites_params)
      FreelancerMailer.notice_invites_sent(@freelancer).deliver
      flash[:notice] = "Thank you for helping make the AVJ network bigger, you'll earn a $50 credit for each reference that accepts your invite"
      redirect_to freelancer_root_path
    else
      flash[:error] = "An error occurred, please review your information."
      render :index
    end
  end

  private
  def friend_invites_params
    params.require(:freelancer).permit(
        friend_invites_attributes: [:email, :name]
    )
  end
end
class Company::NotificationsController < Company::BaseController
  def index
    @messages = current_user.messages.order('created_at DESC')
    # TODO: This needs to instead pull from all messages in jobs, filtering by what the company *didn't* make
  end

end
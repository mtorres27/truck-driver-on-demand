class NotificationsController < ApplicationController
  before_action :set_notification

  def show
    authorize @notification
    @notification.mark_as_read
    redirect_to @notification.url
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end
end

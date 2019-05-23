class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications_channel_#{params['notifications_stream_id']}"
  end

  def unsubscribed
    super
  end

  def receive(payload)
    user = User.find(payload['id'])
    unread_notifications = user.notifications.unread
    ActionCable.server.broadcast "notifications_channel_#{payload['id']}", count: unread_notifications.count
  end

  private

  def render_notifications(notifications)
    ApplicationController.renderer.render(partial: 'shared/notifications', locals: { notifications: notifications })
  end
end

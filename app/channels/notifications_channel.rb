class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications_channel_#{params['notifications_stream_id']}"
  end

  def unsubscribed
    user = User.find(params['notifications_stream_id'])
    user.update_attribute(:currently_logged_in, false)
    super
  end

  def receive(payload)
    user = User.find(payload['id'])
    unread_notifications = user.notifications.unread
    last_notifications = user.notifications.to_show
    notifications = (unread_notifications + last_notifications).uniq
    ActionCable.server.broadcast "notifications_channel_#{payload['id']}", message: render_notifications(notifications), count: unread_notifications.count
  end

  private

  def render_notifications(notifications)
    ApplicationController.renderer.render(partial: 'shared/notifications', locals: { notifications: notifications })
  end
end

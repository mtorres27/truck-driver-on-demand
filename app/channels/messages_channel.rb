class MessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "messages_channel_#{params['chat_room_id']}"
  end

  def receive(payload)
    message = Message.new(payload['message'])
    if payload['authorable_type'] == 'Company'
      message.authorable = Company.find(payload['company_id'])
      message.receivable = Freelancer.find(payload['freelancer_id'])
    elsif payload['authorable_type'] == 'Freelancer'
      message.authorable = Freelancer.find(payload['freelancer_id'])
      message.receivable = Company.find(payload['company_id'])
    end
    if message.save
      ActionCable.server.broadcast "messages_channel_#{payload['chat_room_id']}", message: render_message(message)
      message.send_email_notifications
    end
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'shared/message', locals: { message: message })
  end
end

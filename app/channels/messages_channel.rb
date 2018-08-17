class MessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "messages_channel_#{params['chat_room_id']}"
  end

  def receive(payload)
    job = Job.find(payload['job_id'])
    message = job.messages.new(payload['message'])
    if payload['authorable_type'] == 'Company'
      message.authorable = job.company
    elsif payload['authorable_type'] == 'Freelancer'
      message.authorable = job.freelancer
    end
    if message.save
      ActionCable.server.broadcast "messages_channel_#{payload['job_id']}", message: render_message(message)
      message.send_email_notifications
    end
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'shared/message', locals: { message: message })
  end
end

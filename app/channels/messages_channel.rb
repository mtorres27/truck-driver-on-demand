# frozen_string_literal: true

class MessagesChannel < ApplicationCable::Channel

  def subscribed
    stream_from "messages_channel_#{params['chat_room_id']}"
  end

  def receive(payload)
    message = Message.new(payload["message"])
    if payload["authorable_type"] == "Company"
      message.authorable = Company.find(payload["company_id"])
      message.receivable = Freelancer.find(payload["freelancer_id"])
    elsif payload["authorable_type"] == "Freelancer"
      message.authorable = Freelancer.find(payload["freelancer_id"])
      message.receivable = Company.find(payload["company_id"])
    end
    return unless message.save

    chat_room_number = "#{payload['company_id']}-#{payload['freelancer_id']}"
    ActionCable.server.broadcast("messages_channel_Company-#{chat_room_number}",
                                 message: render_message(message, payload["authorable_type"] == "Company"))
    ActionCable.server.broadcast("messages_channel_Freelancer-#{chat_room_number}",
                                 message: render_message(message, payload["authorable_type"] == "Freelancer"))
    message.send_email_notifications
  end

  private

  def render_message(message, user_is_author)
    ApplicationController.renderer.render(partial: "shared/message",
                                          locals: {
                                            message: message,
                                            user_is_author: user_is_author,
                                            is_admin: false,
                                          })
  end

end

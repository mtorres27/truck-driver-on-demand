# frozen_string_literal: true

class JobInviteMailerPreview < ActionMailer::Preview

  def invite_to_quote
    JobInviteMailer.invite_to_quote(Driver.last, Job.last)
  end

end

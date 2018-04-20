class JobInviteMailerPreview < ActionMailer::Preview

  def invite_to_quote
    JobInviteMailer.invite_to_quote(Freelancer.last, Job.last)
  end

end

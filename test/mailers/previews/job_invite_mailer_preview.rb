# Preview all emails at http://localhost:3000/rails/mailers/job_invite_mailer
class JobInviteMailerPreview < ActionMailer::Preview
  def invite_to_quote
    JobInviteMailer.invite_to_quote(Freelancer.first, Job.last)
  end

end

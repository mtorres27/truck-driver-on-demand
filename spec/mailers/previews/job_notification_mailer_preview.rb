# frozen_string_literal: true

class JobNotificationMailerPreview < ActionMailer::Preview

  def notify_job_posting
    JobNotificationMailer.notify_job_posting(Freelancer.last, Job.last)
  end

end

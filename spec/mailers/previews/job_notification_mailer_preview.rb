# frozen_string_literal: true

class JobNotificationMailerPreview < ActionMailer::Preview

  def notify_job_posting
    JobNotificationMailer.notify_job_posting(Driver.last, Job.last)
  end

end

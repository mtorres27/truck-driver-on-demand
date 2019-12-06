# frozen_string_literal: true

class JobNotificationMailer < ApplicationMailer

  # rubocop:disable Metrics/MethodLength
  def notify_job_posting(driver, job)
    @driver = driver
    @job = job
    headers "X-SMTPAPI" => {
      sub: {
        "%driver_name%" => [@driver.first_name_and_initial],
        "%job_title%" => [@job.title],
        "%job_summary%" => [@job.summary],
        "%job_location%" => ["#{@job.address}, #{@job.state_province}"],
        "%company_name%" => [@job.company.name],
        "%job_id%" => [@job.id],
        "%root_url%" => [ENV["host_url"]],
      },
      filters: {
        templates: {
          settings: {
            enable: 1,
            template_id: "bb88c982-78c3-4d92-8e7d-c4ba67fbc93c",
          },
        },
      },
    }.to_json
    mail(to: @driver.email, subject: I18n.t("job_posted_in_the_area_email_subject"))
  end
  # rubocop:enable Metrics/MethodLength

  def notify_job_posting_company(company, job)
    @job = job
    headers "X-SMTPAPI" => {
      sub: {
        "%user_name%" => [company.company_user.first_name_and_initial],
        "%job_id%" => [@job.id],
        "%root_url%" => [ENV["host_url"]],
      },
      filters: {
        templates: {
          settings: {
            enable: 1,
            template_id: "c220f885-4e59-497c-b931-36f991f55e05",
          },
        },
      },
    }.to_json
    mail(to: company.company_user.email, subject: "Your new Truckker job post")
  end

end

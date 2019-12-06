# frozen_string_literal: true

class JobInviteMailer < ApplicationMailer

  def invite_to_quote(driver, job)
    @driver = driver
    @job = job
    headers "X-SMTPAPI" => {
      sub: {
        "%driver_name%" => [@driver.first_name_and_initial],
        "%job_title%" => [@job.title],
        "%company_name%" => [@job.company.name],
        "%job_id%" => [@job.id],
        "%root_url%" => [ENV["host_url"]],
      },
      filters: {
        templates: {
          settings: {
            enable: 1,
            template_id: "30dcf956-5c86-4283-bc3c-78fbc4c59f38",
          },
        },
      },
    }.to_json
    mail(to: @driver.email, subject: I18n.t("invitation_to_quote_email_subject"))
  end

end

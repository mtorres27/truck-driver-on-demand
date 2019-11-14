# frozen_string_literal: true

class CompanyMailer < ApplicationMailer

  # rubocop:disable Metrics/MethodLength
  def notice_job_complete_company(company_user, driver, job)
    @company = company_user.company
    @driver = driver
    @job = job
    headers "X-SMTPAPI" => {
      sub: {
        "%company_name%" => [@company.name],
        "%driver_name%" => [@driver.first_name_and_initial],
        "%job_title%" => [@job.title],
        "%job_id%" => [@job.id],
        "%root_url%" => [ENV['host_url']],
      },
      filters: {
        templates: {
          settings: {
            enable: 1,
            template_id: "5cd708d2-5518-4fdd-b598-98d945579cf1",
          },
        },
      },
    }.to_json
    mail(to: company_user.email, subject: "Welcome to Truckker!")
  end

  def notice_message_received(company_user, driver, message)
    @company = company_user.company
    @driver = driver
    @message = message
    headers "X-SMTPAPI" => {
      sub: {
        "%company_name%" => [@company.name],
        "%driver_name%" => [@driver.first_name_and_initial],
        "%message_body%" => [@message.body],
        "%driver_id%" => [@driver.id],
        "%root_url%" => [ENV['host_url']],
      },
      filters: {
        templates: {
          settings: {
            enable: 1,
            template_id: "af59fa5c-1330-4011-b9d7-f545943186db",
          },
        },
      },
    }.to_json
    mail(to: company_user.email, subject: "Received message from driver")
  end
  # rubocop:enable Metrics/MethodLength

  def notice_message_sent(company, driver, message)
    @company = company
    @driver = driver
    @message = message
    headers "X-SMTPAPI" => {
      sub: {
        "%sender_name%" => [@company.name],
        "%recipient_name%" => [@driver.first_name_and_initial],
        "%message_body%" => [@message.body],
      },
      filters: {
        templates: {
          settings: {
            enable: 1,
            template_id: "c8cd4c3a-e14c-4a5e-97bc-4ad97806b5b3",
          },
        },
      },
    }.to_json
    mail(to: @company.owner.email, subject: "Message Sent")
  end

  def notice_driver_review(company_user, driver, review)
    @company = company_user.company
    @driver = driver
    @review = review
    headers "X-SMTPAPI" => {
      sub: {
        "%company_name%" => [@company.name],
        "%driver_name%" => [@driver.first_name_and_initial],
        "%root_url%" => [ENV['host_url']],
      },
      filters: {
        templates: {
          settings: {
            enable: 1,
            template_id: "77964885-8367-441b-aeec-dc356f76d8c1",
          },
        },
      },
    }.to_json
    mail(to: company_user.email, subject: "Driver has left a review")
  end

  def notice_added_as_collaborator(company_user, job)
    @company_user = company_user
    @job = job
    headers "X-SMTPAPI" => {
      sub: {
        "%company_user_name%" => [@company_user.first_name_and_initial],
        "%job_title%" => [@job.title],
        "%job_id%" => [@job.id],
        "%root_url%" => [ENV['host_url']],
      },
      filters: {
        templates: {
          settings: {
            enable: 1,
            template_id: "13092274-f005-4164-8b3e-90c5d5ecfb49",
          },
        },
      },
    }.to_json
    mail(to: @company_user.email, subject: "You were added as a collaborator on this job")
  end

  # rubocop:disable Metrics/MethodLength
  def welcome_new_company_user(company_user, password)
    @company = company_user.company
    @company_user = company_user
    @password = password
    headers "X-SMTPAPI" => {
      sub: {
        "%company_name%" => [@company.name],
        "%company_user_name%" => [@company_user.first_name_and_initial],
        "%company_user_id%" => [@company_user.id],
        "%password%" => [@password],
        "%root_url%" => [ENV['host_url']],
      },
      filters: {
        templates: {
          settings: {
            enable: 1,
            template_id: "39db3fd2-91aa-4cf1-a5d8-fa3aaba0fd60",
          },
        },
      },
    }.to_json
    mail(to: @company_user.email, subject: "You were invited to join the team")
  end
  # rubocop:enable Metrics/MethodLength

end

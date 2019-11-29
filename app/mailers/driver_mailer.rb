# frozen_string_literal: true

class DriverMailer < ApplicationMailer

  def send_confirmation_code(driver, confirmation_code)
    @driver = driver
    headers "X-SMTPAPI" => {
      sub: {
        "%driver_name%" => [@driver.first_name_and_initial],
        "%confirmation_code%" => [confirmation_code]
      },
      filters: {
        templates: {
          settings: {
            enable: 1,
            template_id: "e37bd9b0-4e27-4a04-aff1-734e278402c0",
          },
        },
      },
    }.to_json
    mail(to: @driver.email, subject: "Here's your truckker confirmation code")
  end

  def request_profile_verification(driver)
    @driver = driver
    headers "X-SMTPAPI" => {
      sub: {
        "%driver_name%" => [@driver.first_name_and_initial],
        "%driver_email%" => [@driver.email],
        "%driver_id%" => [@driver.id],
        "%root_url%" => [ENV['host_url']],
      },
      filters: {
        templates: {
          settings: {
            enable: 1,
            template_id: "15291d85-bb06-49cc-86c6-cbc7ad75cd82",
          },
        },
      },
    }.to_json
    mail(to: "info@truckker.com", subject: "Driver applied for profile verification")
  end

  def verify_your_identity(driver)
    @driver = driver
    headers "X-SMTPAPI" => {
      sub: {
        "%driver_name%" => [@driver.first_name_and_initial],
        "%root_url%" => [ENV['host_url']],
      },
      filters: {
        templates: {
          settings: {
            enable: 1,
            template_id: "18270d2f-c774-48e5-941e-d2d6134eb52e",
          },
        },
      },
    }.to_json
    mail(to: @driver.email, subject: "Welcome to Truckker!")
  end

  # rubocop:disable Metrics/MethodLength
  def notice_job_complete_driver(company, driver, job)
    @company = company
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
            template_id: "aed5f24a-4506-4ba8-85eb-57fa75dce6c6",
          },
        },
      },
    }.to_json
    mail(to: @driver.email, subject: "Welcome to Truckker!")
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def notice_message_received(company, driver, message)
    @company = company
    @driver = driver
    @message = message
    headers "X-SMTPAPI" => {
      sub: {
        "%company_name%" => [@company.name],
        "%driver_name%" => [@driver.first_name_and_initial],
        "%message_body%" => [@message.body],
        "%company_id%" => [@company.id],
        "%root_url%" => [ENV['host_url']],
      },
      filters: {
        templates: {
          settings: {
            enable: 1,
            template_id: "60a5a920-94e2-4eb7-a407-38df67b1c850",
          },
        },
      },
    }.to_json
    mail(to: @driver.email, subject: "Received message from company")
  end
  # rubocop:enable Metrics/MethodLength

  def notice_company_review(company, driver, review)
    @company = company
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
            template_id: "d2bd83f0-1986-4c17-999c-b9f2460e2744",
          },
        },
      },
    }.to_json
    mail(to: @driver.email, subject: "Company has left a review")
  end

  def notice_received_declined_quote(driver, company, job)
    @driver = driver
    @company = company
    @job = job
    headers "X-SMTPAPI" => {
      sub: {
        "%driver_name%" => [@driver.first_name_and_initial],
        "%company_name%" => [@company.name],
        "%job_title%" => [@job.title],
        "%root_url%" => [ENV['host_url']],
      },
      filters: {
        templates: {
          settings: {
            enable: 1,
            template_id: "9a9afe3d-ea17-430c-b9d8-4e02af620d81",
          },
        },
      },
    }.to_json
    mail(to: @driver.email, subject: "Company has selected another driver")
  end

end

# frozen_string_literal: true

class AdminMailer < ApplicationMailer

  def notify_driver_onboarding_completed(driver)
    # @driver = driver
    # headers "X-SMTPAPI" => {
    #   sub: {
    #     "%driver_name%" => [@driver.first_name_and_initial],
    #     "%root_url%" => [ENV["host_url"]],
    #   },
    #   filters: {
    #     templates: {
    #       settings: {
    #         enable: 1,
    #         template_id: "<ID_GOES_HERE>",
    #       },
    #     },
    #   },
    # }.to_json
    # Admin.find_each do |admin|
    #   mail(to: admin.email, subject:"A new driver completed their profile!")
    # end
  end

end

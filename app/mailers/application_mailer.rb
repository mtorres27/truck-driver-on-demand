# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base

  default from: "Truckker <the.team@truckker.com>", template_path: "mailers", template_name: "default"
  layout "mailer"

end

class ApplicationMailer < ActionMailer::Base
  default from: 'AV Junction <the.team@avjunction.com>', template_path: 'mailers', template_name: 'default'
  layout 'mailer'
end

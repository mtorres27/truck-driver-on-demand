class ApplicationMailer < ActionMailer::Base
  default from: 'AV Junction <info@avjunction.com>', template_path: 'mailers', template_name: 'default'
  layout 'mailer'
end

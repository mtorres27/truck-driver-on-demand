class JobInviteMailer < ApplicationMailer
  default from: 'AV Junction <info@avjunction.com>'

  def invite_to_quote(freelancer, job)
    @freelancer = freelancer
    @job = job
    mail(to: @freelancer.email, subject: I18n.t('invitation_to_quote_email_subject'))
  end
end


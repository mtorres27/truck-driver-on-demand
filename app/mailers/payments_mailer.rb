class PaymentsMailer < ApplicationMailer
  default from: 'AV Junction <info@avjunction.com>'

  def request_funds_company(company, freelancer, job)
    @company = company
    @freelancer = freelancer
    @job = job
    mail(to: @company.email, subject: @freelancer.name has been accepted the work order. It%Qs time to fund the job.
  end

  def request_payout_company(company, freelancer, job)
    @company = company
    @freelancer = freelancer
    @job = job
    mail(to: @company.email, subject: @freelancer.name has requested a payout.
  end

  def notice_funds_freelancer(company, freelancer, job)
    @company = company
    @freelancer = freelancer
    @job = job
    mail(to: @freelancer.email, subject: @company.name has funded your job. It%Qs time to start working!
  end

  def notice_payout_freelancer(company, freelancer, job)
    @company = company
    @freelancer = freelancer
    @job = job
    mail(to: @freelancer.email, subject: @company.name has release a payout.
  end
end
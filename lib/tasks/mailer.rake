namespace :mailer do
  desc "Send funding reminder to companies"

  task reminder_funds_company: :environment do
    Quote.find_all.each do |quote|
      if quote.state == :accepted && !quote.paid_by_company? && quote.accepted_at == Time.zone.today - 7.days
        applicant = quote.applicant
        PaymentsMailer.reminder_funds_company(applicant.company, applicant.freelancer, applicant.job)
      end
    end
  end

  desc "Send payout due reminder to companies"

  task reminder_payout_company: :environment do
    Payment.find_all.each do |payment|
      if payment.issued_on == Time.zone.today - 7.days && payment.paid_on.nil?
        job = payment.job
        freelancer = job.applicants.where({state: "accepted"}).first
        PaymentsMailer.reminder_payout_company(payment.company, freelancer, job, payment).deliver
      end
    end
  end
end
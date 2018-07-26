class PaymentsMailer < ApplicationMailer
  def request_funds_company(company, freelancer, job)
    @company = company
    @freelancer = freelancer
    @job = job
    headers 'X-SMTPAPI' => {
        sub: {
            '%freelancer_name%' => [@freelancer.first_name_and_initial],
            '%company_name%' => [@company.name],
            '%root_url%' => [root_url],
            '%job_id%' => [@job.id],
            '%job_title%' => [@job.title],
            '%job_currency%' => [@job.currency.upcase],
            '%job_accepted_quote_total_amount%' => [@job.contract_price]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '0b75c8ac-69c0-4cb1-bce8-ad02f16d6087'
                }
            }
        }
    }.to_json
    mail(to: @company.email, subject: @freelancer.first_name_and_initial + " has been accepted the work order. It's time to fund the job.")
  end

  def wait_for_funds_freelancer(company, freelancer, job)
    @company = company
    @freelancer = freelancer
    @job = job
    headers 'X-SMTPAPI' => {
        sub: {
            '%freelancer_name%' => [@freelancer.first_name_and_initial],
            '%company_name%' => [@company.name],
            '%root_url%' => [root_url],
            '%job_id%' => [@job.id],
            '%job_title%' => [@job.title],
            '%job_currency%' => [@job.currency.upcase],
            '%job_accepted_quote_total_amount%' => [@job.contract_price]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: 'b7f6a3e0-7d1a-42a3-b8ff-4c2b801eede9'
                }
            }
        }
    }.to_json
    mail(to: @freelancer.email, subject: @freelancer.first_name_and_initial + " has been accepted the work order. It's time to fund the job.")
  end

  def request_payout_company(company, freelancer, job, payment)
    @company = company
    @freelancer = freelancer
    @job = job
    @payment = payment
    headers 'X-SMTPAPI' => {
        sub: {
            '%freelancer_name%' => [@freelancer.first_name_and_initial],
            '%company_name%' => [@company.name],
            '%root_url%' => [root_url],
            '%job_id%' => [@job.id],
            '%job_title%' => [@job.title],
            '%payment_description%' => [@payment.description],
            '%payment_id%' => [@payment.id]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '00fa149f-01cb-4c13-b389-e77af9f56ff6'
                }
            }
        }
    }.to_json
    mail(to: @company.email, subject: @freelancer.first_name_and_initial + " has requested a payout.")
  end

  def reminder_funds_company(company, freelancer, job)
    @company = company
    @freelancer = freelancer
    @job = job
    headers 'X-SMTPAPI' => {
        sub: {
            '%freelancer_name%' => [@freelancer.first_name_and_initial],
            '%company_name%' => [@company..name],
            '%root_url%' => [root_url],
            '%job_id%' => [@job.id],
            '%job_title%' => [@job.title],
            '%job_currency%' => [@job.currency.upcase],
            '%job_accepted_quote_total_amount%' => [@job.contract_price]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: 'c9a88f40-18f7-4d26-9993-c253948da568'
                }
            }
        }
    }.to_json
    mail(to: @company.email, subject: "Reminder that you need to fund the project")
  end

  def reminder_payout_company(company, freelancer, job, payment)
    @company = company
    @freelancer = freelancer
    @job = job
    @payment = payment
    headers 'X-SMTPAPI' => {
        sub: {
            '%freelancer_name%' => [@freelancer.first_name_and_initial],
            '%company_name%' => [@company..name],
            '%root_url%' => [root_url],
            '%job_id%' => [@job.id],
            '%job_title%' => [@job.title],
            '%payment_description%' => [@payment.description],
            '%payment_id%' => [@payment.id]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: 'acbe9b3e-6b5f-4ca7-bc34-8e372d86f0f6'
                }
            }
        }
    }.to_json
    mail(to: @company.email, subject: "Reminder payout is due")
  end

  def notice_funds_freelancer(company, freelancer, job)
    @company = company
    @freelancer = freelancer
    @job = job
    headers 'X-SMTPAPI' => {
        sub: {
            '%freelancer_name%' => [@freelancer.first_name_and_initial],
            '%company_name%' => [@company.name],
            '%root_url%' => [root_url],
            '%job_id%' => [@job.id],
            '%job_title%' => [@job.title],
            '%job_currency%' => [@job.currency.upcase],
            '%job_accepted_quote_total_amount%' => [@job.contract_price]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '430192fa-a9b4-4fdf-80da-d444c80162e8'
                }
            }
        }
    }.to_json
    mail(to: @freelancer.email, subject: @company.name + " has funded your job. It's time to start working!")
  end

  def notice_funds_company(company, freelancer, job)
    @company = company
    @freelancer = freelancer
    @job = job
    headers 'X-SMTPAPI' => {
        sub: {
            '%freelancer_name%' => [@freelancer.first_name_and_initial],
            '%company_name%' => [@company.name],
            '%root_url%' => [root_url],
            '%job_id%' => [@job.id],
            '%job_title%' => [@job.title],
            '%job_currency%' => [@job.currency.upcase],
            '%job_accepted_quote_total_amount%' => [@job.contract_price]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: 'a332e7a8-7301-48e5-afaf-17b3186863d1'
                }
            }
        }
    }.to_json
    mail(to: @company.email, subject: "Confirmation that the job #{@job.title} has been funded in full")
  end

  def notice_payout_freelancer(company, freelancer, job, payment)
    @company = company
    @freelancer = freelancer
    @job = job
    @payment = payment
    headers 'X-SMTPAPI' => {
        sub: {
            '%freelancer_name%' => [@freelancer.first_name_and_initial],
            '%company_name%' => [@company.name],
            '%root_url%' => [root_url],
            '%job_id%' => [@job.id],
            '%job_title%' => [@job.title],
            '%payment_description%' => [@payment.description],
            '%payment_id%' => [@payment.id]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '98a28a6d-1c98-40d8-bc00-c33a2e5fdc80'
                }
            }
        }
    }.to_json
    mail(to: @freelancer.email, subject: @company.name + " has approved your payout.")
  end
end

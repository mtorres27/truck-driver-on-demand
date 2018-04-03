class CompanyMailer < ApplicationMailer

  def notice_job_complete_company(company, freelancer, job)
    @company = company
    @freelancer = freelancer
    @job = job
    headers 'X-SMTPAPI' => {
        sub: {
            '%company_name%' => [@company.name],
            '%freelancer_name%' => [@freelancer.name],
            '%job_title%' => [@job.title],
            '%job_id%' => [@job.id],
            '%root_url%' => [root_url]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '5cd708d2-5518-4fdd-b598-98d945579cf1'
                }
            }
        }
    }.to_json
    mail(to: @company.email, subject: 'Welcome to AVJunction!')
  end

  def notice_received_new_quote_from_freelancer(freelancer, company, job, quote)
    @company = company
    @freelancer = freelancer
    @quote = quote
    @job = job
    headers 'X-SMTPAPI' => {
        sub: {
            '%company_name%' => [@company.name],
            '%freelancer_name%' => [@freelancer.name],
            '%quote_pay_type%' => [@quote.pay_type],
            '%quote_amount%' => [@quote.amount],
            '%job_currency%' => [@job.currency.upcase],
            '%job_title%' => [@job.title],
            '%job_id%' => [@job.id],
            '%root_url%' => [root_url]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '692a6c63-dd11-4e73-895e-85d93715693b'
                }
            }
        }
    }.to_json
    mail(to: @company.email, subject: 'Received new quote from freelancer')
  end

  def notice_received_negociated_quote_from_freelancer(company, freelancer, quote, job)
    @company = company
    @freelancer = freelancer
    @quote = quote
    @job = job
    headers 'X-SMTPAPI' => {
        sub: {
            '%company_name%' => [@company.name],
            '%freelancer_name%' => [@freelancer.name],
            '%quote_pay_type%' => [@quote.pay_type],
            '%quote_amount%' => [@quote.amount],
            '%job_currency%' => [@job.currency.upcase],
            '%job_title%' => [@job.title],
            '%job_id%' => [@job.id],
            '%root_url%' => [root_url]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '63a9383e-9451-465b-b655-52da742d85e0'
                }
            }
        }
    }.to_json
    mail(to: @company.email, subject: 'Received negociated quote from freelancer')
  end

  def notice_received_accepted_quote_from_freelancer(company, freelancer, quote, job)
    @company = company
    @freelancer = freelancer
    @quote = quote
    @job = job
    headers 'X-SMTPAPI' => {
        sub: {
            '%company_name%' => [@company.name],
            '%freelancer_name%' => [@freelancer.name],
            '%quote_pay_type%' => [@quote.pay_type],
            '%quote_amount%' => [@quote.amount],
            '%job_currency%' => [@job.currency.upcase],
            '%job_title%' => [@job.title],
            '%job_id%' => [@job.id],
            '%root_url%' => [root_url]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '5db14abe-b3de-4fc7-80ee-bf18dc6dbece'
                }
            }
        }
    }.to_json
    mail(to: @company.email, subject: 'Freelancer has accepted your offer')
  end

  def notice_received_declined_quote_from_freelancer(company, freelancer, job)
    @company = company
    @freelancer = freelancer
    @quote = quote
    @job = job
    headers 'X-SMTPAPI' => {
        sub: {
            '%company_name%' => [@company.name],
            '%freelancer_name%' => [@freelancer.name],
            '%job_title%' => [@job.title],
            '%root_url%' => [root_url]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '811b73a8-e286-49a4-8372-54d8b480c4fe'
                }
            }
        }
    }.to_json
    mail(to: @company.email, subject: 'Received declined quote from freelancer')
  end

  def notice_message_received(company, freelancer, job, message)
    @company = company
    @freelancer = freelancer
    @message = message
    @job = job
    headers 'X-SMTPAPI' => {
        sub: {
            '%company_name%' => [@company.name],
            '%freelancer_name%' => [@freelancer.name],
            '%message_body%' => [@message.body],
            '%job_id%' => [@job.id],
            '%root_url%' => [root_url]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: 'af59fa5c-1330-4011-b9d7-f545943186db'
                }
            }
        }
    }.to_json
    mail(to: @company.email, subject: 'Received message from freelancer')
  end

  def notice_message_sent(company, freelancer, message)
    @company = company
    @freelancer = freelancer
    @message = message
    headers 'X-SMTPAPI' => {
        sub: {
            '%sender_name%' => [@company.name],
            '%recipient_name%' => [@freelancer.name],
            '%message_body%' => [@message.body]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: 'c8cd4c3a-e14c-4a5e-97bc-4ad97806b5b3'
                }
            }
        }
    }.to_json
    mail(to: @company.email, subject: 'Message Sent')
  end

  def notice_freelancer_review(company, freelancer, review)
    @company = company
    @freelancer = freelancer
    @review = review
    headers 'X-SMTPAPI' => {
        sub: {
            '%company_name%' => [@company.name],
            '%freelancer_name%' => [@freelancer.name],
            '%root_url%' => [root_url]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '77964885-8367-441b-aeec-dc356f76d8c1'
                }
            }
        }
    }.to_json
    mail(to: @company.email, subject: 'Freelancer has left a review')
  end
end


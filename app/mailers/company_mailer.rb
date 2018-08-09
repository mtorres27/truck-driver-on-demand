class CompanyMailer < ApplicationMailer

  def notice_job_complete_company(company, freelancer, job)
    @company = company
    @freelancer = freelancer
    @job = job
    headers 'X-SMTPAPI' => {
        sub: {
            '%company_name%' => [@company.name],
            '%freelancer_name%' => [@freelancer.first_name_and_initial],
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

  def notice_message_received(company, freelancer, job, message)
    @company = company
    @freelancer = freelancer
    @message = message
    @job = job
    headers 'X-SMTPAPI' => {
        sub: {
            '%company_name%' => [@company.name],
            '%freelancer_name%' => [@freelancer.first_name_and_initial],
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
            '%recipient_name%' => [@freelancer.first_name_and_initial],
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

  def notice_work_order_accepted(company, freelancer, job)
    @company = company
    @freelancer = freelancer
    @job = job
    headers 'X-SMTPAPI' => {
        sub: {
            '%company_name%' => [@company.name],
            '%freelancer_name%' => [@freelancer.first_name_and_initial],
            '%job_title%' => [@job.title],
            '%job_id%' => [@job.id],
            '%root_url%' => [root_url]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '623136de-4771-4f89-979d-5afe4d58ec9e'
                }
            }
        }
    }.to_json
    mail(to: @company.email, subject: 'Received work order from company')
  end

  def notice_freelancer_review(company, freelancer, review)
    @company = company
    @freelancer = freelancer
    @review = review
    headers 'X-SMTPAPI' => {
        sub: {
            '%company_name%' => [@company.name],
            '%freelancer_name%' => [@freelancer.first_name_and_initial],
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


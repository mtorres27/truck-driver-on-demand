class CompanyMailer < ApplicationMailer

  def notice_job_complete_company(company_user, freelancer, job)
    @company = company_user.company
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
    mail(to: company_user.email, subject: 'Welcome to AVJunction!')
  end

  def notice_message_received(company_user, freelancer, job, message)
    @company = company_user.company
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
    mail(to: company_user.email, subject: 'Received message from freelancer')
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
    mail(to: @company.owner.email, subject: 'Message Sent')
  end

  def notice_work_order_accepted(company_user, freelancer, job)
    @company = company_user.company
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
    mail(to: company_user.email, subject: 'Received work order from company')
  end

  def notice_freelancer_review(company_user, freelancer, review)
    @company = company_user.company
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
    mail(to: company_user.email, subject: 'Freelancer has left a review')
  end

  def notice_added_as_collaborator(company_user, job)
    @company_user = company_user
    @job = job
    headers 'X-SMTPAPI' => {
        sub: {
            '%company_user_name%' => [@company_user.first_name_and_initial],
            '%job_title%' => [@job.title],
            '%job_id%' => [@job.id],
            '%root_url%' => [root_url]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '13092274-f005-4164-8b3e-90c5d5ecfb49'
                }
            }
        }
    }.to_json
    mail(to: @company_user.email, subject: 'You were added as a collaborator on this job')
  end

  def welcome_new_company_user(company_user, password)
    @company = company_user.company
    @company_user = company_user
    @password = password
    headers 'X-SMTPAPI' => {
        sub: {
            '%company_name%' => [@company.name],
            '%company_user_name%' => [@company_user.first_name_and_initial],
            '%company_user_id%' => [@company_user.id],
            '%password%' => [@password],
            '%root_url%' => [root_url]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '39db3fd2-91aa-4cf1-a5d8-fa3aaba0fd60'
                }
            }
        }
    }.to_json
    mail(to: @company_user.email, subject: 'You were invited to join the team')
  end
end


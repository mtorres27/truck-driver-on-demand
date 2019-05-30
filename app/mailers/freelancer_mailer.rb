class FreelancerMailer < ApplicationMailer

  def verify_your_identity(freelancer)
    @freelancer = freelancer
    headers 'X-SMTPAPI' => {
        sub: {
            '%freelancer_name%' => [@freelancer.first_name_and_initial],
            '%root_url%' => [root_url]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '18270d2f-c774-48e5-941e-d2d6134eb52e'
                }
            }
        }
    }.to_json
    mail(to: @freelancer.email, subject: 'Welcome to AVJunction!')
  end

  def notice_job_complete_freelancer(company, freelancer, job)
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
                    template_id: 'aed5f24a-4506-4ba8-85eb-57fa75dce6c6'
                }
            }
        }
    }.to_json
    mail(to: @freelancer.email, subject: 'Welcome to AVJunction!')
  end

  def notice_message_received(company, freelancer, message)
    @company = company
    @freelancer = freelancer
    @message = message
    headers 'X-SMTPAPI' => {
        sub: {
            '%company_name%' => [@company.name],
            '%freelancer_name%' => [@freelancer.first_name_and_initial],
            '%message_body%' => [@message.body],
            '%company_id%' => [@company.id],
            '%root_url%' => [root_url]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '60a5a920-94e2-4eb7-a407-38df67b1c850'
                }
            }
        }
    }.to_json
    mail(to: @freelancer.email, subject: 'Received message from company')
  end

  def notice_company_review(company, freelancer, review)
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
                    template_id: 'd2bd83f0-1986-4c17-999c-b9f2460e2744'
                }
            }
        }
    }.to_json
    mail(to: @freelancer.email, subject: 'Company has left a review')
  end

  def notice_received_declined_quote(freelancer, company, job)
    @freelancer = freelancer
    @company = company
    @job = job
    headers 'X-SMTPAPI' => {
        sub: {
            '%freelancer_name%' => [@freelancer.first_name_and_initial],
            '%company_name%' => [@company.name],
            '%job_title%' => [@job.title],
            '%root_url%' => [root_url]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '9a9afe3d-ea17-430c-b9d8-4e02af620d81'
                }
            }
        }
    }.to_json
    mail(to: @freelancer.email, subject: 'Company has selected another freelancer')
  end
end


class JobNotificationMailer < ApplicationMailer
  def notify_job_posting(freelancer, job)
    @freelancer = freelancer
    @job = job
    headers 'X-SMTPAPI' => {
        sub: {
            '%freelancer_name%' => [@freelancer.first_name_and_initial],
            '%job_title%' => [@job.title],
            '%job_summary%' => [@job.summary],
            '%job_location%' => ["#{@job.address}, #{@job.state_province}"],
            '%company_name%' => [@job.company.name],
            '%job_id%' => [@job.id],
            '%root_url%' => [root_url]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: 'bb88c982-78c3-4d92-8e7d-c4ba67fbc93c'
                }
            }
        }
    }.to_json
    mail(to: @freelancer.email, subject: I18n.t('job_posted_in_the_area_email_subject'))
  end

  def notify_job_posting_company(company, job)
    @job = job
    headers 'X-SMTPAPI' => {
        sub: {
            '%user_name%' => [company.company_user.first_name_and_initial],
            '%job_id%' => [@job.id],
            '%root_url%' => [root_url]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: 'c220f885-4e59-497c-b931-36f991f55e05'
                }
            }
        }
    }.to_json
    mail(to: company.company_user.email, subject: 'Your new AV Junction job post')
  end
end

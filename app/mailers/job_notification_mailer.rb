class JobNotificationMailer < ApplicationMailer
  def notify_job_posting(freelancer, job)
    @freelancer = freelancer
    @job = job
    headers 'X-SMTPAPI' => {
        sub: {
            '%freelancer_name%' => [@freelancer.first_name_and_initial],
            '%job_title%' => [@job.title],
            '%job_location%' => ["#{@job.address}, #{@job.state_province}"],
            '%job_type%' => [@job.job_type.present? ? I18n.t("enumerize.job_types.#{@job.job_type}") : nil],
            '%job_function%' => [@job.job_function.present? ? I18n.t("enumerize.#{@job.job_type}_job_functions.#{@job.job_function}") : nil],
            '%job_market%' => [@job.job_market.present? ? I18n.t("enumerize.#{@job.job_type}_job_markets.#{@job.job_market}") : nil],
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
end

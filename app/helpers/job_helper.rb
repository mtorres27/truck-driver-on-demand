module JobHelper
  def stateful_company_postings_job_path(job)
    if job.created?
      company_postings_job_path(job)
    elsif job.published?
      company_postings_job_applicants_path(job) \
    elsif job.quoted?
      company_postings_job_applicants_path(job) \
    elsif job.negotiated?
      company_postings_job_contract_path(job) \
    elsif job.contracted?
      company_postings_job_messages_path(job) \
    else
      company_postings_job_payments_path(job)
    end
  end

  def job_state_label(job)
    mappings = {
      created: :default,
      published: :primary,
      quoted: :success,
      negotiated: :info,
      contracted: :warning,
      completed: :danger
    }

    content_tag(:span, class: "job-state label label-#{mappings[job.state.to_sym]}") do
      job.state.text
    end
  end
end

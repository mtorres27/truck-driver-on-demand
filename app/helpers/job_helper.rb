module JobHelper
  def stateful_company_job_path(job)
    if job.created?
      company_job_path(job)
    elsif job.published?
      company_job_applicants_path(job) \
    elsif job.quoted?
      company_job_applicants_path(job) \
    elsif job.negotiated?
      edit_company_job_contract_path(job) \
    elsif job.contracted?
      company_job_messages_path(job) \
    else
      company_job_review_path(job)
    end
  end

  def job_state_label(job)
    mappings = {
      created: :default,
      published: :primary,
      quoted: :success,
      negotiated: :info,
      contracted: :warning,
      completed: :danger,
      declined: :danger
    }

    content_tag(:span, class: "job_state label label-#{mappings[job.state.to_sym]}") do
      job.state.text
    end
  end
end

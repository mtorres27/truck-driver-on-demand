module JobHelper
  def stateful_company_job_path(job)
    if job.created?
      company_job_path(job)
    elsif job.published?
      company_job_applicants_path(job) \
    elsif job.negotiated?
      company_job_contract_path(job) \
    elsif job.contracted?
      company_job_messages_path(job) \
    else
      company_job_payments_path(job)
    end
  end
end

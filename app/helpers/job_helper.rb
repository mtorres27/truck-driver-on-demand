module JobHelper
  def stateful_company_job_path(job)
    if job.contracted? || job.completed?
      company_job_path(job)
    elsif job.negotiated?
      company_contract_path(job) \
    else
      company_job_path(job)
    end
  end
end

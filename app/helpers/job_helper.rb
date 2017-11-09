module JobHelper
  def stateful_company_job_path(job)
    if job.created?
      company_job_path(job)
    elsif job.published?
      company_job_applicants_path(job) \
    elsif job.quoted?
      company_job_applicants_path(job) \
    elsif job.negotiated?
      if job.contract_sent != true
        edit_company_job_work_order_path(job) \
      else
        company_job_path(job)
      end
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

    sym = job.state.to_sym
    t = job.state.text

    if current_freelancer and job.applicants.where({freelancer_id: current_freelancer.id, state: "declined"}).count > 0
      sym = :declined
      t = "declined"
    end

    content_tag(:span, class: "job_state label label-#{mappings[sym]}") do
      t
    end
  end


  def is_favourite_job(job)
    favourites = current_freelancer.job_favourites.where({job_id: job.id})

    if favourites.count == 0
      return false
    else
      return true
    end

  end
end

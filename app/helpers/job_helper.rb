module JobHelper
  def stateful_company_job_path(job)
    if job.created?
      company_job_path(job)
    elsif job.published? && job.applicants.count == 0
      company_job_path(job)
    elsif job.published? && job.applicants.count > 0
      company_job_applicants_path(job)
    elsif job.quoted?
      company_job_applicants_path(job)
    elsif job.negotiated?
      company_job_path(job)
    elsif job.contracted?
      company_job_path(job)
    else
      company_job_review_path(job)
    end
  end

  def job_state_label(job)
    mappings = {
      created: :default,
      published: :primary,
      quoted: :success,
      negotiated: :success,
      contracted: :active,
      completed: :danger,
      declined: :danger
    }

    if job.state == 'published' && job.applicants.count == 0
      sym = :created
      t = 'Not Published'
    else
      sym = job.state.to_sym
      t = job.state.text
    end

    if current_user.freelancer? && job.applicants.where({freelancer_id: current_user.id, state: 'declined'}).count > 0
      sym = :declined
      t = 'declined'
    end

    content_tag(:span, class: "avj-tag avj-tag--#{mappings[sym]}") do
      t
    end
  end


  def is_favourite_job(job)
    favourites = current_user.job_favourites.where({job_id: job.id})

    if favourites.count == 0
      return false
    else
      return true
    end

  end
end

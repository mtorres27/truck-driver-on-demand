module JobHelper
  def stateful_company_job_path(job)
    if job.created?
      company_job_path(job)
    elsif job.published?
      company_job_applicants_path(job)
    elsif job.quoted?
      company_job_applicants_path(job)
    elsif job.negotiated?
      if job.contract_sent != true
        if job.company.plan_id.blank?
          company_job_applicants_path(job)
        else
          edit_company_job_work_order_path(job)
        end
      else
        company_job_path(job)
      end
    elsif job.contracted?
      company_job_messages_path(job)
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

    sym = job.state.to_sym
    t = job.state.text

    if current_user.freelancer? && job.applicants.where({freelancer_id: current_user.id, state: "declined"}).count > 0
      sym = :declined
      t = "declined"
    end

    content_tag(:span, class: "tag tag--#{mappings[sym]}") do
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

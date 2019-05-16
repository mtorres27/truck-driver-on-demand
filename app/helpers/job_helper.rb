module JobHelper
  def job_state_label(job)
    mappings = {
      created: :draft,
      published: :published,
    }

    sym = job.state.to_sym

    content_tag(:span, nil, class: "avj-tag avj-tag__#{mappings[sym]}")
  end
end

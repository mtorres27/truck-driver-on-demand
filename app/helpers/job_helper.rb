# frozen_string_literal: true

module JobHelper

  def job_state_label(job)
    mappings = {
      created: :draft,
      published: :published,
    }

    sym = job.state.to_sym

    content_tag(:span, nil, class: "truckker-tag truckker-tag__#{mappings[sym]}")
  end

end

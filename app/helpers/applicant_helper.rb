# frozen_string_literal: true

module ApplicantHelper

  def applicant_state_label(applicant)
    mappings = {
      ignored: :default,
      quoting: :info,
      accepted: :success,
      declined: :danger,
    }
    applicant.state = "quoting" if applicant.state == "interested"

    content_tag(:span, class: "applicant_state label label-#{mappings[applicant.state.to_sym]}") do
      applicant.state.text
    end
  end

  def random_append
    (0...rand(4..8)).map { ("a".."z").to_a[rand(26)] }.join
  end

end

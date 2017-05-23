module ApplicantHelper

  def applicant_state_label(applicant)
    mappings = {
      interested: :warning,
      ignored: :default,
      quoting: :info,
      accepted: :success
    }

    content_tag(:span, class: "applicant-state label label-#{mappings[applicant.state.to_sym]}") do
      applicant.state.text
    end
  end

end

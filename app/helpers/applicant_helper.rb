module ApplicantHelper

  def applicant_state_label(applicant)
    mappings = {
      interested: :warning,
      ignored: :default,
      quoting: :info,
      accepted: :success
    }

    content_tag(:span, class: "applicant_state label label-#{mappings[applicant.state.to_sym]}") do
      applicant.state.text
    end
  end

  def quote_state_label(quote)
    mappings = {
      declined: :danger,
      pending: :info,
      accepted: :success
    }

    content_tag(:span, class: "applicant_state label label-#{mappings[quote.state.to_sym]}") do
      quote.state.text
    end
  end

end

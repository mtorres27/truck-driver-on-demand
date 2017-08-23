module ApplicantHelper

  def applicant_state_label(applicant)
    mappings = {
      ignored: :default,
      quoting: :info,
      accepted: :success
    }
    if applicant.state == "interested" 
      applicant.state = "quoting"
    end

    p "applicant state "
    p applicant

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

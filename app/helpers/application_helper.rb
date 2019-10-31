# frozen_string_literal: true

module ApplicationHelper

  def attachment_image_link(attachment)
    return unless attachment

    content_tag(:a, href: attachment.url, target: "_blank") do
      if attachment.mime_type&.include?("image")
        image_tag(attachment.url, class: "attachment-image")
      else
        attachment.original_filename
      end
    end
  end

  def image?(url)
    if [".png", ".gif", ".jpg", ".jpeg", ".svg"].include?(File.extname(url).downcase)
      true
    else
      false
    end
  end

  def seen_onboarding?
    if cookies[:onboarding]
      true
    else
      false
    end
  end

  def closed_prereg_message?
    if cookies[:prereg_message]
      true
    else
      false
    end
  end

  def set_has_seen_onboarding
    cookies[:onboarding] = { value: true }
  end

  def set_has_closed_prereg_message
    cookies[:prereg_message] = { value: true }
  end

  def calc_distance_from(freelancer)
    if current_user.nil? || current_user.admin? || (current_user.company_user? && current_user.company.lat.nil?)
      return "N/A"
    end

    point = OpenStruct.new(lat: current_company.lat, lng: current_company.lng)
    @freelancer_profiles = FreelancerProfile.where(freelancer_id: freelancer.id).with_distance(point)
    @freelancer = freelancer

    return "N/A" if @freelancer.freelancer_profile.lat.nil?

    distance_from(@freelancer, @freelancer_profiles)
  end

  def proper_website_link(url)
    if url.include?("http://") || url.include?("https://")
      url
    else
      "http://" + url
    end
  end

end

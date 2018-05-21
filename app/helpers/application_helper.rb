module ApplicationHelper

  def current_admin
    current_user.meta_type == 'Admin' ? current_user.meta : nil unless current_user.nil?
  end

  def current_freelancer
    current_user.meta_type == 'Freelancer' ? current_user.meta : nil unless current_user.nil?
  end

  def current_company
    current_user.meta_type == 'Company' ? current_user.meta : nil unless current_user.nil?
  end

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

  def is_image(url)
    if ['.png', '.gif', '.jpg', '.jpeg', '.svg'].include?(File.extname(url).downcase)
      return true
    else
      return false
    end
  end

  def has_seen_onboarding
    if cookies[:onboarding]
      return true
    else
      return false
    end
  end

  def has_closed_prereg_message
    if cookies[:prereg_message]
      return true
    else
      return false
    end
  end


  def set_has_seen_onboarding
    cookies[:onboarding] = { value: true }
  end

  def set_has_closed_prereg_message
    cookies[:prereg_message] = { value: true }
  end


  def calc_distance_from(freelancer)
    if current_company.nil? || current_company.lat.nil?
      return "N/A"
    end

    point = OpenStruct.new(:lat => current_company.lat, :lng => current_company.lng)
    @freelancer = Freelancer.where({id: freelancer.id}).with_distance(point).first

    if @freelancer.lat.nil?
      return "N/A"
    end
    return distance_from(@freelancer)
  end

  def proper_website_link(url)
    if url.include?("http://") or url.include?("https://")
      return url
    else
      return "http://"+url
    end
  end
end

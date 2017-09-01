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

  def is_image(url)
    if ['.png', '.gif', '.jpg', '.jpeg', '.svg'].include?(File.extname(url))
      return true
    else
      return false
    end
  end

  def calc_distance_from(freelancer)
    if current_company.lat.nil?
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

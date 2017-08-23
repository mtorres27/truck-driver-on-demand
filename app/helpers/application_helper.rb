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
end

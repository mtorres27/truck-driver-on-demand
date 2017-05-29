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
end

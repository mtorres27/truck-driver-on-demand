# frozen_string_literal: true

require "image_processing/mini_magick"
include ImageProcessing::MiniMagick

class FreelancerInsuranceUploader < Shrine

  plugin :store_dimensions
  plugin :processing
  plugin :default_url
  plugin :determine_mime_type

  process(:store) do |io, _context|
    resize_to_limit!(io.download, 300, 300) if image?(io)
  end

  Attacher.default_url do
    "#{name}/missing.pdf"
  end

  protected

  def image?(new_file)
    new_file.content_type.start_with? "image"
  end

end

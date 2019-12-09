# frozen_string_literal: true

require "image_processing/mini_magick"

include ImageProcessing::MiniMagick

class LicenseUploader < Shrine

  plugin :store_dimensions
  plugin :processing
  plugin :default_url
  plugin :validation_helpers
  plugin :remove_invalid
  plugin :determine_mime_type

  Attacher.default_url do
    "#{name}/missing.png"
  end

  Attacher.validate do
    validate_mime_type_inclusion %w[image/png image/gif image/jpg image/jpeg]
  end

end

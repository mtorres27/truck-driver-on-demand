require "image_processing/mini_magick"

include ImageProcessing::MiniMagick

class AvatarUploader < Shrine
  plugin :store_dimensions
  plugin :processing
  plugin :default_url

  process(:store) do |io, context|
    resize_to_limit!(io.download, 300, 300)
  end

  Attacher.default_url do
    "#{name}/missing.png"
  end
end

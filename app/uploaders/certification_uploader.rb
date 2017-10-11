require "image_processing/mini_magick"

include ImageProcessing::MiniMagick

class CertificationUploader < Shrine
  plugin :store_dimensions
  plugin :processing
  plugin :default_url

  process(:store) do |io, context|
    resize_to_limit!(io.download, 300, 300)
  end

  Attacher.default_url do
    "#{name}/missing.pdf"
  end
end

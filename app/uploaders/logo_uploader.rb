require "image_processing/mini_magick"

include ImageProcessing::MiniMagick

class LogoUploader < Shrine
  plugin :store_dimensions
  plugin :processing

  process(:store) do |io, context|
    resize_to_limit!(io.download, 300, 300)
  end
end

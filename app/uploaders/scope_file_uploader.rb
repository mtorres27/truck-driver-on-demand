require "image_processing/mini_magick"

include ImageProcessing::MiniMagick

class ScopeFileUploader < Shrine
  plugin :store_dimensions
  plugin :processing
  plugin :default_url
  plugin :validation_helpers
  plugin :remove_invalid

  process(:store) do |io, context|
    resize_to_fill(io.download, 150, 150)
  end

 
end

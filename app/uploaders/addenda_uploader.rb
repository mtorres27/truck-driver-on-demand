require "image_processing/mini_magick"

include ImageProcessing::MiniMagick

class AddendaUploader < Shrine
  plugin :store_dimensions
  plugin :processing
  plugin :default_url

  process(:store) do |io, context|
    if :image?
      resize_to_limit!(io.download, 300, 300)
    end
  end

  Attacher.default_url do
    "#{name}/missing.png"
  end

  protected
    def image?(new_file)
      new_file.content_type.start_with? 'image'
    end
end

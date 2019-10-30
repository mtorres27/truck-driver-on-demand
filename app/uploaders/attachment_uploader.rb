# frozen_string_literal: true

class AttachmentUploader < Shrine

  plugin :determine_mime_type
  plugin :data_uri, filename: lambda { |content_type|
    extension = MIME::Types[content_type][0].preferred_extension
    "File.#{extension}"
  }

end

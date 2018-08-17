class AttachmentUploader < Shrine
  plugin :determine_mime_type
  plugin :data_uri, filename: ->(content_type) do
    extension = MIME::Types[content_type][0].preferred_extension
    "File.#{extension}"
  end
end

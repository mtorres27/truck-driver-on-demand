class Attachment < ApplicationRecord
  include AddendaUploader[:file]
end

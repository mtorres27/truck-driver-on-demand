class FeaturedProject < ApplicationRecord
  belongs_to :company
  include FeaturedProjectUploader[:file]
end

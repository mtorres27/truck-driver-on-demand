class Company < ApplicationRecord
  include Loginable

  has_many :identities, as: :loginable

  mount_uploader :logo, LogoUploader
end

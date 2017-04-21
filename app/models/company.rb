# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  name       :string           not null
#  tagline    :string
#  address    :string
#  logo       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Company < ApplicationRecord
  include Loginable

  has_many :identities, as: :loginable

  mount_uploader :logo, LogoUploader
end

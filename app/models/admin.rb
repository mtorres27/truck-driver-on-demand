# == Schema Information
#
# Table name: admins
#
#  id         :integer          not null, primary key
#  token      :string
#  email      :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Admin < ApplicationRecord
  include Loginable

  has_many :identities, as: :loginable, dependent: :destroy

  validates :email, uniqueness: { case_sensitive: false }
end

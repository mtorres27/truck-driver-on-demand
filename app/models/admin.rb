# == Schema Information
#
# Table name: admins
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Admin < ApplicationRecord
  include Loginable

  has_many :identities, as: :loginable

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
end

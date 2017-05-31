# == Schema Information
#
# Table name: admins
#
#  id         :integer          not null, primary key
#  token      :string
#  email      :citext           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Admin < ApplicationRecord
  include Loginable

  has_many :identities, as: :loginable, dependent: :destroy
end

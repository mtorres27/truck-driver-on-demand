# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  name       :string           not null
#  tagline    :string
#  address    :string
#  logo_data  :text
#  disabled   :boolean          default("false"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Company < ApplicationRecord
  include Loginable
  include Disableable

  has_many :identities, as: :loginable

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
end

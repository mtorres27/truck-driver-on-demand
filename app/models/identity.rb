# == Schema Information
#
# Table name: identities
#
#  id              :integer          not null, primary key
#  loginable_type  :string
#  loginable_id    :integer
#  provider        :string           not null
#  uid             :string           not null
#  last_sign_in_at :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Identity < ApplicationRecord
  belongs_to :loginable, polymorphic: true

  validates :loginable, presence: true
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: [:provider, :loginable_type] }
end

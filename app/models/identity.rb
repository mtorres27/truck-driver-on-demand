# == Schema Information
#
# Table name: identities
#
#  id              :integer          not null, primary key
#  loginable_type  :string
#  loginable_id    :integer          not null
#  provider        :string           not null
#  uid             :string           not null
#  last_sign_in_at :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Identity < ApplicationRecord
  belongs_to :loginable, polymorphic: true

  validates :uid, uniqueness: { scope: [:provider, :loginable_type] }
end

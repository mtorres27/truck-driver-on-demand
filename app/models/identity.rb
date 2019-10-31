# frozen_string_literal: true

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
# Indexes
#
#  index_identities_on_loginable_type_and_loginable_id      (loginable_type,loginable_id)
#  index_identities_on_loginable_type_and_provider_and_uid  (loginable_type,provider,uid) UNIQUE
#

class Identity < ApplicationRecord

  belongs_to :loginable, polymorphic: true

end

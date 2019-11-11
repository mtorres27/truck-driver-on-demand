# frozen_string_literal: true

# == Schema Information
#
# Table name: identities
#
#  id              :bigint           not null, primary key
#  loginable_type  :string           not null
#  loginable_id    :bigint           not null
#  provider        :string           not null
#  uid             :string           not null
#  last_sign_in_at :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Identity < ApplicationRecord

  belongs_to :loginable, polymorphic: true

end

# == Schema Information
#
# Table name: plans
#
#  id                :integer          not null, primary key
#  name              :string
#  code              :string
#  trial_period      :integer
#  subscription_fee  :decimal(10, 2)
#  fee_schema        :json
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  description       :text
#  period            :string           default("yearly")
#  is_canadian       :boolean          default(FALSE)
#  job_posting_limit :integer
#  user_limit        :integer          default(1)
#

class Plan < ApplicationRecord
  has_many :companies, dependent: :nullify

end

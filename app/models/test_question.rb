# == Schema Information
#
# Table name: test_questions
#
#  id             :bigint           not null, primary key
#  driver_test_id :bigint           not null
#  question       :string           not null
#  options        :jsonb            not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class TestQuestion < ApplicationRecord

  belongs_to :driver_test

  validates :question, :options, presence: true

end

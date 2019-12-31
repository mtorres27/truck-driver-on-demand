# frozen_string_literal: true

# == Schema Information
#
# Table name: driver_tests
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DriverTest < ApplicationRecord

  default_scope { order(created_at: :asc) }

  has_many :test_questions, dependent: :destroy

  validates :name, presence: true

end

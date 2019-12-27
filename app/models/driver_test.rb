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

  has_many :test_questions, dependent: :destroy

  validates :name, presence: true

end

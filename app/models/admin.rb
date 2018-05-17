# == Schema Information
#
# Table name: admins
#
#  id         :integer          not null, primary key
#  token      :string
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Admin < ApplicationRecord
  has_one :user, as: :meta, dependent: :destroy
  accepts_nested_attributes_for :user

  after_create :confirm_user

  private

  def confirm_user
    user.confirm
  end
end

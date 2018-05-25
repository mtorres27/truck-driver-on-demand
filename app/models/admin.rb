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
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  audited

end

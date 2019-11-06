# frozen_string_literal: true

# == Schema Information
#
# Table name: favourites
#
#  id         :bigint           not null, primary key
#  driver_id  :integer
#  company_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Favourite < ApplicationRecord

  belongs_to :driver
  belongs_to :company

end

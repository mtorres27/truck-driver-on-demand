# frozen_string_literal: true

# == Schema Information
#
# Table name: driver_insurances
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  driver_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  image       :string
#  image_data  :text
#

require "image_processing/mini_magick"
include ImageProcessing::MiniMagick

class DriverInsurance < ApplicationRecord

  include DriverInsuranceUploader[:image]
  belongs_to :driver, class_name: "User", foreign_key: "driver_id"

  after_save :generate_thumbnail

  validates :image_data, presence: true

  def generate_thumbnail
    nil
  end

end

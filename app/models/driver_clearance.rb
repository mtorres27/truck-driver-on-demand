# frozen_string_literal: true

# == Schema Information
#
# Table name: driver_clearances
#
#  id          :bigint           not null, primary key
#  description :text
#  image       :string
#  image_data  :text
#  driver_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "image_processing/mini_magick"
include ImageProcessing::MiniMagick

class DriverClearance < ApplicationRecord

  include DriverClearanceUploader[:image]
  belongs_to :driver, class_name: "User", foreign_key: "driver_id"

  after_save :generate_thumbnail

  validates :image_data, presence: true

  def generate_thumbnail
    nil
  end

end

# frozen_string_literal: true

# == Schema Information
#
# Table name: driver_portfolios
#
#  id         :bigint           not null, primary key
#  name       :text
#  image      :string
#  image_data :text
#  driver_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "image_processing/mini_magick"
include ImageProcessing::MiniMagick

class DriverPortfolio < ApplicationRecord

  include DriverPortfolioUploader[:image]
  belongs_to :driver, class_name: "User", foreign_key: "driver_id"

  after_save :generate_thumbnail

  validates :image_data, presence: true

  def generate_thumbnail
    nil
  end

end

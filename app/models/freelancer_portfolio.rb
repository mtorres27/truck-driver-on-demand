# frozen_string_literal: true

# == Schema Information
#
# Table name: freelancer_portfolios
#
#  id            :integer          not null, primary key
#  name          :text
#  image         :string
#  image_data    :text
#  freelancer_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "image_processing/mini_magick"
include ImageProcessing::MiniMagick

class FreelancerPortfolio < ApplicationRecord

  include FreelancerPortfolioUploader[:image]
  belongs_to :freelancer, class_name: "User", foreign_key: "freelancer_id"

  after_save :generate_thumbnail

  validates :image_data, presence: true

  def generate_thumbnail
    nil
  end

end

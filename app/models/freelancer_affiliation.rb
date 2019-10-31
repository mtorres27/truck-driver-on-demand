# frozen_string_literal: true

# == Schema Information
#
# Table name: freelancer_affiliations
#
#  id            :integer          not null, primary key
#  name          :string
#  image         :string
#  freelancer_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  image_data    :text
#

require "image_processing/mini_magick"
include ImageProcessing::MiniMagick

class FreelancerAffiliation < ApplicationRecord

  include FreelancerAffiliationUploader[:image]
  belongs_to :freelancer, class_name: "User", foreign_key: "freelancer_id"

  after_save :generate_thumbnail

  validates :image_data, presence: true

  def generate_thumbnail
    nil
  end

end

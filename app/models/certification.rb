# frozen_string_literal: true

# == Schema Information
#
# Table name: certifications
#
#  id               :integer          not null, primary key
#  freelancer_id    :integer
#  certificate      :text
#  name             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  thumbnail        :text
#  certificate_data :text
#  cert_type        :string
#

require "image_processing/mini_magick"
include ImageProcessing::MiniMagick

class Certification < ApplicationRecord

  include CertificationUploader[:certificate]
  belongs_to :freelancer, class_name: "User", foreign_key: "freelancer_id"

  extend Enumerize

  after_save :generate_thumbnail

  validates :certificate_data, presence: true

  enumerize :cert_type, in: %i[skill onsite]

  def generate_thumbnail
    nil
  end

end

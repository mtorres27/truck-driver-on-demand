# frozen_string_literal: true

# == Schema Information
#
# Table name: certifications
#
#  id               :bigint           not null, primary key
#  driver_id        :integer
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
  belongs_to :driver, class_name: "User", foreign_key: "driver_id"

  extend Enumerize

  after_save :generate_thumbnail

  validates :certificate_data, presence: true

  enumerize :cert_type, in: %i[skill onsite]

  def generate_thumbnail
    nil
  end

end

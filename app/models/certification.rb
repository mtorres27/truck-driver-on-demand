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
  belongs_to :freelancer, class_name: 'User', foreign_key: 'freelancer_id'

  extend Enumerize

  after_save :generate_thumbnail

  enumerize :cert_type, in: [ :skill, :onsite ]

  def generate_thumbnail
    if self.certificate_data.nil?
      return
    end

    return


    page_index_path = self.certificate_data + "[0]" # first page in PDF
    pdf_page = MiniMagick::Image.read( page_index_path ).first # first item in Magick::ImageList
    filename = "#{id}.pdf"
    pdf_page.write( "/uploads/images/certifications/#{filename}" )

    update_column(:thumbnail, filename)
  end
end

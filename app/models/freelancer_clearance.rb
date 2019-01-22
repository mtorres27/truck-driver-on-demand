# == Schema Information
#
# Table name: freelancer_clearances
#
#  id            :integer          not null, primary key
#  description   :text
#  image         :string
#  image_data    :text
#  freelancer_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "image_processing/mini_magick"
include ImageProcessing::MiniMagick

class FreelancerClearance < ApplicationRecord
  include FreelancerClearanceUploader[:image]
  belongs_to :freelancer, class_name: 'User', foreign_key: 'freelancer_id'

  after_save :generate_thumbnail

  validates :image_data, presence: true

  def generate_thumbnail
    if self.image_data.nil?
      return
    end

    return


    page_index_path = self.image_data + "[0]" # first page in PDF
    pdf_page = MiniMagick::Image.read( page_index_path ).first # first item in Magick::ImageList
    filename = "#{id}.pdf"
    pdf_page.write( "/uploads/freelancer_clearances/#{filename}" )

    update_column(:thumbnail, filename)
  end
end

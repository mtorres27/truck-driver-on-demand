require "image_processing/mini_magick"
include ImageProcessing::MiniMagick

class FreelancerPortfolio < ApplicationRecord
  include FreelancerPortfolioUploader[:image]
  belongs_to :freelancer

  after_save :generate_thumbnail

  def generate_thumbnail
    if self.image_data.nil?
      return
    end

    return


    page_index_path = self.image_data + "[0]" # first page in PDF
    pdf_page = MiniMagick::Image.read( page_index_path ).first # first item in Magick::ImageList
    filename = "#{id}.pdf"
    pdf_page.write( "/uploads/freelancer_portfolios/#{filename}" )

    update_column(:thumbnail, filename)
  end
end

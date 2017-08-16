class Certification < ApplicationRecord
  require "rmagick"
  include CertificationUploader[:certificate]
  belongs_to :freelancer

  after_save :generate_thumbnail

  def generate_thumbnail
    if self.certificate_data.nil?
      return
    end

    page_index_path = self.certificate_data + "[0]" # first page in PDF
    pdf_page = Magick::Image.read( page_index_path ).first # first item in Magick::ImageList
    filename = "#{id}.pdf"
    pdf_page.write( "/uploads/images/certifications/#{filename}" )

    update_column(:thumbnail, filename)
  end
end

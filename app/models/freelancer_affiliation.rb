class FreelancerAffiliation < ApplicationRecord
  include FreelancerAffiliationUploader[:freelancer_affiliation]
  belongs_to :freelancer

  after_save :generate_thumbnail

  def generate_thumbnail
    if self.freelancer_affiliation_data.nil?
      return
    end

    return


    page_index_path = self.freelancer_affiliation_data + "[0]" # first page in PDF
    pdf_page = MiniMagick::Image.read( page_index_path ).first # first item in Magick::ImageList
    filename = "#{id}.pdf"
    pdf_page.write( "/uploads/images/freelancer_affiliation/#{filename}" )

    update_column(:thumbnail, filename)
  end
end

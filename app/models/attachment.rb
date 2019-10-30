# frozen_string_literal: true

# == Schema Information
#
# Table name: attachments
#
#  id         :integer          not null, primary key
#  file_data  :string
#  job_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  title      :string
#

class Attachment < ApplicationRecord

  include AddendaUploader[:file]

end

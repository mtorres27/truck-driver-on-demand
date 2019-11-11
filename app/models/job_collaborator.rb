# frozen_string_literal: true

# == Schema Information
#
# Table name: job_collaborators
#
#  id                    :bigint           not null, primary key
#  job_id                :bigint           not null
#  user_id               :bigint           not null
#  receive_notifications :boolean          default(TRUE)
#

class JobCollaborator < ApplicationRecord

  belongs_to :user
  belongs_to :job

end

# == Schema Information
#
# Table name: job_collaborators
#
#  id                    :integer          not null, primary key
#  job_id                :integer          not null
#  user_id               :integer          not null
#  receive_notifications :boolean          default(TRUE)
#
# Indexes
#
#  index_job_collaborators_on_job_id   (job_id)
#  index_job_collaborators_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (user_id => users.id)
#

class JobCollaborator < ApplicationRecord
  belongs_to :user
  belongs_to :job
end

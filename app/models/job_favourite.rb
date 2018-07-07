# == Schema Information
#
# Table name: job_favourites
#
#  id            :integer          not null, primary key
#  freelancer_id :integer
#  job_id        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class JobFavourite < ApplicationRecord
  belongs_to :freelancer, class_name: 'User', foreign_key: 'freelancer_id'
  belongs_to :job
end

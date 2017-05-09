# == Schema Information
#
# Table name: applicants
#
#  id            :integer          not null, primary key
#  job_id        :integer
#  freelancer_id :integer
#  accepted      :boolean          default("false"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Applicant < ApplicationRecord
  belongs_to :job
  belongs_to :freelancer
  has_many :quotes, dependent: :destroy

  validates :job, presence: true
  validates :freelancer, presence: true
  validates :accepted, uniqueness: { scope: :job_id }, if: :accepted?

  scope :with_pending_quotes, -> {
    joins(:quotes).where(quotes: { rejected: false })
  }

  scope :without_quotes, -> {
    where.not(id: Quote.select(:applicant_id))
  }

  def last_quote
    quots.order(created_at: :desc).first
  end
end

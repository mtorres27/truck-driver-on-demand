# == Schema Information
#
# Table name: applicants
#
#  id            :integer          not null, primary key
#  job_id        :integer          not null
#  freelancer_id :integer          not null
#  state         :string           default("interested"), not null
#  quotes_count  :integer          default("0"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Applicant < ApplicationRecord
  extend Enumerize

  belongs_to :job, counter_cache: true
  belongs_to :freelancer
  has_many :quotes, -> { order(created_at: :desc) }, dependent: :destroy

  validates :job, presence: true
  validates :freelancer, presence: true
  validate :only_one_can_be_accepted

  enumerize :state, in: [
    :interested,
    :ignored,
    :quoting,
    :accepted
  ], predicates: true, scope: true

  scope :with_pending_quotes, -> {
    joins(:quotes).where(quotes: { rejected: false })
  }

  scope :without_quotes, -> {
    where.not(id: Quote.select(:applicant_id))
  }

  def only_one_can_be_accepted
    if accepted? && job.applicants.with_state(:accepted).where.not(id: id).any?
      errors.add(:base, "Only one applicant may be accepted for a job.")
    end
  end
end

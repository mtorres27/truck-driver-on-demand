# == Schema Information
#
# Table name: applicants
#
#  id             :integer          not null, primary key
#  company_id     :integer          not null
#  job_id         :integer          not null
#  freelancer_id  :integer          not null
#  state          :string           default("quoting"), not null
#  quotes_count   :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  messages_count :integer          default(0), not null
#
# Indexes
#
#  index_applicants_on_company_id     (company_id)
#  index_applicants_on_freelancer_id  (freelancer_id)
#  index_applicants_on_job_id         (job_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (freelancer_id => users.id)
#  fk_rails_...  (job_id => jobs.id)
#

class Applicant < ApplicationRecord
  extend Enumerize

  belongs_to :company
  belongs_to :job, counter_cache: true
  belongs_to :freelancer, class_name: "User", foreign_key: 'freelancer_id'
  has_many :messages, -> { includes(:authorable).order(created_at: :desc) }, as: :receivable
  accepts_nested_attributes_for :messages

  validate :only_one_can_be_accepted

  audited

  enumerize :state, in: [
    :ignored,
    :quoting,
    :accepted,
    :declined
  ], predicates: true, scope: true

  def only_one_can_be_accepted
    if accepted? && job.applicants.with_state(:accepted).where.not(id: id).any?
      errors.add(:base, "Only one applicant may be accepted for a job.")
    end
  end

  def request_quote!
    self.state = :quoting
    save
  end

  def accept!
    self.state = :accepted
    save
  end

  def reject!
    self.state = :declined
    save
  end


  def ignore!
    self.state = :ignored
    save
  end
end

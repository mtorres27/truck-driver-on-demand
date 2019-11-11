# frozen_string_literal: true

# == Schema Information
#
# Table name: applicants
#
#  id             :bigint           not null, primary key
#  company_id     :bigint           not null
#  job_id         :bigint           not null
#  driver_id      :bigint           not null
#  state          :string           default("quoting"), not null
#  quotes_count   :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  messages_count :integer          default(0), not null
#

class Applicant < ApplicationRecord

  extend Enumerize

  belongs_to :company
  belongs_to :job, counter_cache: true
  belongs_to :driver, class_name: "User", foreign_key: "driver_id"
  has_many :messages, -> { includes(:authorable).order(created_at: :desc) }, as: :receivable
  accepts_nested_attributes_for :messages

  validate :only_one_can_be_accepted

  audited

  enumerize :state, in: %i[
    ignored
    quoting
    accepted
    declined
  ], predicates: true, scope: true

  def only_one_can_be_accepted
    return unless accepted? && job.applicants.with_state(:accepted).where.not(id: id).any?

    errors.add(:base, "Only one applicant may be accepted for a job.")
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

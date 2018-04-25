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

class Applicant < ApplicationRecord
  extend Enumerize

  belongs_to :company
  belongs_to :job, counter_cache: true
  belongs_to :freelancer
  has_many :quotes, -> { order(created_at: :desc) }, dependent: :destroy
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

  scope :with_pending_quotes, -> {
    joins(:quotes).where(quotes: { state: "pending" })
  }

  scope :without_quotes, -> {
    where.not(id: Quote.select(:applicant_id))
  }

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
    if save
      quote = quotes.where({applicant_id: id}).first
      job.update(contract_price: quote.amount, pay_type: quote.pay_type)
    end
  end

  def reject!
    self.state = :declined
    save
  end


  def ignore!
    self.state = :ignored
    save
  end

  def self.connect_quotes_to_messages
    Applicant.all.each do |applicant|
      applicant.messages.where({has_quote: false}).each do |message|
        applicant.quotes.each do |quote|
          if (message.created_at - quote.created_at).abs < 1
            message.has_quote = true
            message.quote_id = quote.id
            message.save
          end
        end
      end
    end
    Message.where({has_quote: false}).find_each do |message|
      @message_date = message.created_at
      Quote.where()
    end
  end
end

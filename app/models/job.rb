# == Schema Information
#
# Table name: jobs
#
#  id                        :integer          not null, primary key
#  company_id                :integer          not null
#  project_id                :integer          not null
#  title                     :string           not null
#  state                     :string           default("created"), not null
#  summary                   :text             not null
#  scope_of_work             :text
#  budget                    :decimal(10, 2)   not null
#  job_function              :string           not null
#  starts_on                 :date             not null
#  ends_on                   :date
#  duration                  :integer          not null
#  pay_type                  :string
#  freelancer_type           :string           not null
#  keywords                  :text
#  invite_only               :boolean          default(FALSE), not null
#  scope_is_public           :boolean          default(TRUE), not null
#  budget_is_public          :boolean          default(TRUE), not null
#  working_days              :text             default([]), not null, is an Array
#  working_time              :string
#  contract_price            :decimal(10, 2)
#  payment_schedule          :jsonb            not null
#  reporting_frequency       :string
#  require_photos_on_updates :boolean          default(FALSE), not null
#  require_checkin           :boolean          default(FALSE), not null
#  require_uniform           :boolean          default(FALSE), not null
#  addendums                 :text
#  applicants_count          :integer          default(0), not null
#  messages_count            :integer          default(0), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class Job < ApplicationRecord
  extend Enumerize

  belongs_to :company
  belongs_to :project
  has_many :applicants, -> { includes(:freelancer).order(updated_at: :desc) }, dependent: :destroy
  has_many :quotes, -> { order(created_at: :desc) }, through: :applicants
  has_many :messages, -> { order(created_at: :desc) }, as: :receivable
  has_many :change_orders, -> { order(updated_at: :desc) }, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_one :freelancer_review, dependent: :nullify
  has_one :company_review, dependent: :nullify

  accepts_nested_attributes_for :payments, allow_destroy: true, reject_if: :reject_payments

  schema_validations except: :working_days

  audited

  enumerize :job_function, in: [
    :av_installation_technician,
    :av_rental_and_staging_technician,
    :av_programmer
  ]

  enumerize :pay_type, in: [ :fixed, :hourly ]

  enumerize :freelancer_type, in: [ :independent, :av_labor_company ]

  enumerize :state, in: [
    :created,
    :published,
    :quoted,
    :negotiated,
    :contracted,
    :completed
  ], predicates: true, scope: true

  def pre_negotiated?
    %w(created published quoted).include?(state)
  end

  def pre_contracted?
    pre_negotiated? || negotiated?
  end

  enumerize :reporting_frequency, in: [
    :daily,
    :every_other_day,
    :weekly
  ]

  validates :budget, numericality: true, sane_price: true
  validates :job_function, inclusion: { in: job_function.values }
  validates :duration, numericality: { only_integer: true }
  validates :pay_type, inclusion: { in: pay_type.values }, allow_blank: true
  validates :freelancer_type, inclusion: { in: freelancer_type.values }

  def freelancer
    applicants.with_state(:accepted).first&.freelancer
  end

  def payments_sum_paid
    payments.
      select { |p| p.paid_on.present? }.
      sum { |p| p.amount || 0 }
  end

  def payments_sum_outstanding
    payments.
      select { |p| p.paid_on.blank? }.
      sum { |p| p.amount || 0 }
  end

  def payments_sum_total
    payments.
      sum { |p| p.amount || 0 }
  end

  private

    def reject_payments(attrs)
      exists = attrs["id"].present?
      empty = attrs["description"].blank? && attrs["amount"].blank?
      attrs.merge!({ _destroy: 1 }) if exists && empty
      !exists and empty
    end

end

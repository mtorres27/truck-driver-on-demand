# == Schema Information
#
# Table name: jobs
#
#  id                                     :integer          not null, primary key
#  company_id                             :integer          not null
#  project_id                             :integer
#  title                                  :string
#  state                                  :string           default("created"), not null
#  summary                                :text
#  scope_of_work                          :text
#  budget                                 :decimal(10, 2)
#  job_function                           :string
#  starts_on                              :date
#  ends_on                                :date
#  duration                               :integer
#  pay_type                               :string
#  freelancer_type                        :string
#  technical_skill_tags                   :text
#  invite_only                            :boolean          default(FALSE), not null
#  scope_is_public                        :boolean          default(TRUE), not null
#  budget_is_public                       :boolean          default(FALSE), not null
#  working_days                           :text             default([]), not null, is an Array
#  working_time                           :string
#  contract_price                         :decimal(10, 2)
#  payment_schedule                       :jsonb            not null
#  reporting_frequency                    :string
#  require_photos_on_updates              :boolean          default(FALSE), not null
#  require_checkin                        :boolean          default(FALSE), not null
#  require_uniform                        :boolean          default(FALSE), not null
#  addendums                              :text
#  applicants_count                       :integer          default(0), not null
#  messages_count                         :integer          default(0), not null
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  currency                               :string
#  address                                :string
#  lat                                    :decimal(9, 6)
#  lng                                    :decimal(9, 6)
#  formatted_address                      :string
#  contract_sent                          :boolean          default(FALSE)
#  opt_out_of_freelance_service_agreement :boolean          default(FALSE)
#  country                                :string
#  scope_file_data                        :text
#  applicable_sales_tax                   :decimal(10, 2)
#  stripe_charge_id                       :string
#  stripe_balance_transaction_id          :string
#  funds_available_on                     :integer
#  funds_available                        :boolean          default(FALSE)
#  job_type                               :citext
#  job_market                             :citext
#  manufacturer_tags                      :citext
#  company_plan_fees                      :decimal(10, 2)   default(0.0)
#  contracted_at                          :datetime
#  state_province                         :string
#  creation_step                          :string
#  plan_fee                               :decimal(10, 2)   default(0.0)
#  paid_by_company                        :boolean          default(FALSE)
#  total_amount                           :decimal(10, 2)
#  tax_amount                             :decimal(10, 2)
#  stripe_fees                            :decimal(10, 2)
#  amount_subtotal                        :decimal(10, 2)
#  variable_pay_type                      :string
#  overtime_rate                          :decimal(10, 2)
#  payment_terms                          :integer
#
# Indexes
#
#  index_jobs_on_company_id         (company_id)
#  index_jobs_on_manufacturer_tags  (manufacturer_tags)
#  index_jobs_on_project_id         (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (project_id => projects.id)
#

class Job < ApplicationRecord
  extend Enumerize
  include Geocodable
  include PgSearch
  include EasyPostgis
  include ScopeFileUploader[:scope_file]

  belongs_to :company
  belongs_to :project, optional: true
  has_many :applicants, -> { includes(:freelancer).order(updated_at: :desc) }, dependent: :destroy
  has_many :messages, -> { order(created_at: :desc) }, as: :receivable
  has_many :change_orders, -> { order(updated_at: :desc) }, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :attachments, dependent: :destroy
  has_one :freelancer_review, dependent: :nullify
  has_one :company_review, dependent: :nullify
  has_many :job_invites

  accepts_nested_attributes_for :payments, allow_destroy: true, reject_if: :reject_payments
  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :reject_attachments

  attr_accessor :send_contract, :accepted_applicant_id, :enforce_contract_creation, :save_draft

  after_save :check_if_should_do_geocode
  after_save :accept_applicant, if: :enforce_contract_creation

  enumerize :job_type, in: I18n.t('enumerize.job_types').keys

  enumerize :working_time, in: [
    :standard_workday,
    :evenings,
    :weekend,
    :any_time
  ]

  enumerize :pay_type, in: I18n.t('enumerize.job.pay_type').keys

  enumerize :variable_pay_type, in: [ :hourly, :daily ]

  enumerize :freelancer_type, in: [ :independent, :service_provider ]

  enumerize :country, in: [
    :at, :au, :be, :ca, :ch, :de, :dk, :es, :fi, :fr, :gb, :hk, :ie, :it, :jp, :lu, :nl, :no, :nz, :pt, :se, :sg, :us
  ]

  enumerize :state, in: [
    :created,
    :published,
    :quoted,
    :negotiated,
    :contracted,
    :completed
  ], predicates: true, scope: true

  validates :budget, numericality: true, sane_price: true, if: :creation_completed?
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, if: -> { step_job_details? || creation_completed? }
  validates :pay_type, inclusion: { in: pay_type.values }, allow_blank: true, if: :creation_completed?
  validates :freelancer_type, inclusion: { in: freelancer_type.values }, allow_blank: true, if: :creation_completed?
  validates :job_function, :freelancer_type, presence: true, if: :is_published?
  validates :title, :summary, :address, :currency, :country, presence: true, if: -> { step_job_details? || is_published? }
  validates :freelancer_type, :job_type, :job_market, :job_function, presence: true, if: -> { is_published? }
  validates :accepted_applicant_id, presence: true, if: :enforce_contract_creation
  validates :contract_price, :payment_terms, numericality: { greater_than_or_equal_to: 1 }, if: :enforce_contract_creation
  validate :scope_or_file, if: :creation_completed?
  validate :validate_number_of_payments, if: :creation_completed?
  validate :validate_payments_total, if: :creation_completed?
  validate :validate_sales_tax, if: :creation_completed?

  schema_validations except: :working_days

  serialize :technical_skill_tags
  serialize :manufacturer_tags

  audited

  pg_search_scope :search, against: {
    title: "A",
    job_type: "B",
    job_market: "B",
    technical_skill_tags: "B",
    manufacturer_tags: "B",
    job_function: "B",
    summary: "C",
    scope_of_work: "C"
  }, using: {
    tsearch: { prefix: true, any_word: true }
  }

  def pre_negotiated?
    %w(created published quoted).include?(state)
  end

  def work_order_in_draft?
    pre_negotiated? && freelancer.present? && !contract_sent?
  end

  def is_published?
    state != :created
  end

  def pre_contracted?
    pre_negotiated? || work_order_in_draft?
  end

  def work_order
    "WO-"+(id.to_s.rjust(5, '0'))
  end

  enumerize :reporting_frequency, in: [
    :daily,
    :every_other_day,
    :weekly
  ]

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

  def gpayments_sum_paid
    payments_sum_paid * (1 + ((applicable_sales_tax||0) / 100))
  end

  def gpayments_sum_outstanding
    payments_sum_outstanding * (1 + ((applicable_sales_tax||0) / 100))
  end

  def gpayments_sum_total
    payments_sum_total * (1 + ((applicable_sales_tax||0) / 100))
  end

  def city_state_country
    str = ""
    str += "#{address}, " if address.present?
    str += "#{CS.states(country.to_sym)[state_province.to_sym]}, " if state_province.present?
    str += "#{country.upcase}" if country.present?
    str
  end

  def creation_completed?
    creation_step == "wicked_finish"
  end

  def self.all_job_functions
    I18n.t("enumerize.system_integration_job_functions").merge(I18n.t("enumerize.live_events_staging_and_rental_job_functions"))
  end

  def self.all_job_markets
    I18n.t("enumerize.system_integration_job_markets").merge(I18n.t("enumerize.live_events_staging_and_rental_job_markets"))
  end

  private

  def scope_or_file
    if scope_of_work.blank? and scope_file_url.nil?
      errors.add(:scope_of_work, "Either a scope of work or a scope file attachment is required")
    end
  end

  def reject_payments(attrs)
    exists = attrs["id"].present?
    empty = attrs["description"].blank? && attrs["amount"].blank?
    attrs.merge!({ _destroy: 1 }) if exists && empty
    !exists and empty
  end

  def reject_attachments(attrs)
    exists = attrs["id"].present?
    empty = attrs["file"].blank? && attrs["title"].blank?
    attrs.merge!({ _destroy: 1 }) if exists && empty
    !exists and empty
  end

  def check_if_should_do_geocode
    return unless saved_changes.include?("address") || (!address.nil? && lat.nil?)
    do_geocode
    update_columns(lat: lat, lng: lng)
  end

  def step_job_details?
    creation_step == "candidate_details"
  end

  def accept_applicant
    applicants.where(id: accepted_applicant_id).first&.update_attribute(:state, "accepted")
  end

  def validate_number_of_payments
    if send_contract == "true" && pay_type == "fixed"
      remaining_payments = payments.reject(&:marked_for_destruction?)
      errors.add(:number_of_payments, 'A minimum of 1 payment is required') if remaining_payments.empty?
    end
  end

  def validate_payments_total
    if send_contract == "true" && pay_type == "fixed"
      total = payments.inject(0) { |sum, e| sum + e.amount if e.amount.present? }
      errors.add(:total_of_payments, 'The total amount of payments doesn\'t match with the work order amount') if total != contract_price
    end
  end

  def validate_sales_tax
    if send_contract == "true"
      errors.add(:applicable_sales_tax, 'You should set the applicable sales tax!') if applicable_sales_tax.nil?
    end
  end
end

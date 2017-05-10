# == Schema Information
#
# Table name: jobs
#
#  id                        :integer          not null, primary key
#  project_id                :integer
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
#  invite_only               :boolean          default("false"), not null
#  scope_is_public           :boolean          default("true"), not null
#  budget_is_public          :boolean          default("true"), not null
#  working_days              :text
#  working_times             :string
#  contract_price            :decimal(10, 2)
#  contract_paid             :decimal(10, 2)
#  payment_schedule          :text
#  reporting_frequency       :string
#  require_photos_on_updates :boolean          default("false"), not null
#  require_checkin           :boolean          default("false"), not null
#  require_uniform           :boolean          default("false"), not null
#  addendums                 :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class Job < ApplicationRecord
  extend Enumerize

  belongs_to :project
  has_many :applicants, dependent: :destroy
  has_many :quotes, through: :applicants
  has_many :messages, dependent: :destroy
  has_many :payments, dependent: :destroy

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
  ], predicates: true

  validates :project, presence: true
  validates :title, presence: true
  validates :summary, presence: true
  validates :budget, presence: true, numericality: true, sane_price: true
  validates :job_function, presence: true, inclusion: { in: job_function.values }
  validates :starts_on, presence: true
  validates :duration, presence: true, numericality: { only_integer: true }
  validates :pay_type, inclusion: { in: pay_type.values }, allow_blank: true
  validates :freelancer_type, presence: true, inclusion: { in: freelancer_type.values }
end

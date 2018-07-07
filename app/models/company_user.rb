# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  first_name             :string
#  last_name              :string
#  type                   :string
#  messages_count         :integer          default(0), not null
#  company_id             :integer
#
# Indexes
#
#  index_users_on_company_id            (company_id)
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class CompanyUser < User

  audited

  belongs_to :company

  before_validation :initialize_company

  attr_accessor :accept_terms_of_service, :accept_privacy_policy, :accept_code_of_conduct,
                :enforce_profile_edit, :user_type

  validates_acceptance_of :accept_terms_of_service
  validates_acceptance_of :accept_privacy_policy
  validates_acceptance_of :accept_code_of_conduct

  delegate :registration_completed?, to: :company

  protected

  def confirmation_required?
    registration_completed?
  end

  private

  def initialize_company
    self.company ||= build_company
  end

  def send_confirmation_notification?
    false
  end

end

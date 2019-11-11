# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
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
#  company_id             :bigint
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :bigint
#  invitations_count      :integer          default(0)
#  phone_number           :string
#  role                   :string
#  enabled                :boolean          default(TRUE)
#

class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :notifications, as: :receivable, dependent: :destroy

  validates :email, uniqueness: { case_sensitive: false }
  validates :first_name, :last_name, :phone_number, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def first_name_and_initial
    "#{first_name} #{last_name&.first}"
  end

  def name_initials
    "#{first_name.first}#{last_name.first}"
  end

  def admin?
    is_a?(Admin)
  end

  def driver?
    is_a?(Driver)
  end

  def company_user?
    is_a?(CompanyUser)
  end

  def user_data
    if is_a?(CompanyUser)
      company
    elsif is_a?(Driver)
      driver_profile
    end
  end

end

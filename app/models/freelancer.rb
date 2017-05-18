# == Schema Information
#
# Table name: freelancers
#
#  id                       :integer          not null, primary key
#  email                    :string           not null
#  name                     :string           not null
#  address                  :string
#  formatted_address        :string
#  area                     :string
#  lat                      :decimal(9, 6)
#  lng                      :decimal(9, 6)
#  pay_unit_time_preference :string
#  pay_per_unit_time        :integer
#  tagline                  :string
#  bio                      :text
#  keywords                 :string
#  years_of_experience      :integer          default("0"), not null
#  profile_views            :integer          default("0"), not null
#  projects_completed       :integer          default("0"), not null
#  available                :boolean          default("true"), not null
#  disabled                 :boolean          default("false"), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class Freelancer < ApplicationRecord
  include PgSearch
  include Loginable
  include Geocodable
  include Disableable
  include AvatarUploader[:avatar]

  has_many :identities, as: :loginable, dependent: :destroy
  has_many :applicants, -> { order(updated_at: :desc) }, dependent: :destroy
  # has_many :jobs, through: :applicants
  has_many :messages, -> { order(created_at: :desc) }, as: :authorable, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :pay_per_unit_time, numericality: true, allow_blank: true
  validates :years_of_experience, numericality: { only_integer: true }

  pg_search_scope :search, against: {
    name: "A",
    keywords: "B",
    tagline: "C",
    bio: "C"
  }, using: {
    tsearch: { prefix: true }
  }

  def stars
    4.5 # TODO
  end
end

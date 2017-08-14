# == Schema Information
#
# Table name: freelancers
#
#  id                       :integer          not null, primary key
#  token                    :string
#  email                    :citext           not null
#  name                     :string           not null
#  avatar_data              :text
#  address                  :string
#  formatted_address        :string
#  area                     :string
#  lat                      :decimal(9, 6)
#  lng                      :decimal(9, 6)
#  pay_unit_time_preference :string
#  pay_per_unit_time        :integer
#  tagline                  :string
#  bio                      :text
#  keywords                 :citext
#  years_of_experience      :integer          default(0), not null
#  profile_views            :integer          default(0), not null
#  projects_completed       :integer          default(0), not null
#  available                :boolean          default(TRUE), not null
#  disabled                 :boolean          default(FALSE), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class Freelancer < ApplicationRecord
  include PgSearch
  include Loginable
  include Geocodable
  include Disableable
  include AvatarUploader[:avatar]
  include EasyPostgis

  has_many :identities, as: :loginable, dependent: :destroy
  has_many :applicants, -> { order(updated_at: :desc) }, dependent: :destroy
  has_many :jobs, through: :applicants
  has_many :messages, -> { order(created_at: :desc) }, as: :authorable, dependent: :destroy
  has_many :company_reviews, dependent: :destroy
  has_many :freelancer_reviews, dependent: :nullify

  validates :years_of_experience, numericality: { only_integer: true }

  audited

  # after_validation :queue_geocode

  pg_search_scope :search, against: {
    name: "A",
    keywords: "B",
    skills: "B",
    tagline: "C",
    bio: "C"
  }, using: {
    tsearch: { prefix: true, any_word: true }
  }

  def rating
    freelancer_reviews.average("(#{FreelancerReview::RATING_ATTRS.map(&:to_s).join('+')}) / #{FreelancerReview::RATING_ATTRS.length}").round
  end

  def self.avg_rating(freelancer)
    if freelancer.freelancer_reviews_count == 0
      return nil
    end

    return freelancer.rating
  end
end

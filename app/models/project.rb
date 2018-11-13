# == Schema Information
#
# Table name: projects
#
#  id                  :integer          not null, primary key
#  company_id          :integer          not null
#  external_project_id :string
#  name                :string           not null
#  formatted_address   :string
#  lat                 :decimal(9, 6)
#  lng                 :decimal(9, 6)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_on_projects_loc                  (st_geographyfromtext((((('SRID=4326;POINT('::text || lng) || ' '::text) || lat) || ')'::text)))
#  index_projects_on_company_id           (company_id)
#  index_projects_on_external_project_id  (external_project_id)
#  index_projects_on_name                 (name)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#

class Project < ApplicationRecord
  include Geocodable
  extend Enumerize
  include PgSearch

  belongs_to :company
  has_many :jobs, -> { order(updated_at: :desc) }, dependent: :destroy

  audited

  pg_search_scope :search, against: {
      name: "A",
      external_project_id: "B"
  }, using: {
      tsearch: { prefix: true, any_word: true }
  }

  def currency
    jobs.first.nil? ? nil : jobs.first.currency
  end

  def contract_value
    jobs.sum { |job| job.contract_price || 0 }
  end
end

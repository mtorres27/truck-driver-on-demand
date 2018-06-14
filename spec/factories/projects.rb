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

FactoryBot.define do
  factory :project do
    external_project_id { Faker::Code.unique.isbn }
    name { Faker::Company.unique.name }
  end
end

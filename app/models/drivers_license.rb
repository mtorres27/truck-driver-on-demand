# == Schema Information
#
# Table name: drivers_licenses
#
#  id                :bigint           not null, primary key
#  driver_profile_id :bigint           not null
#  license_data      :text
#  license_number    :string
#  exp_date          :date
#  license_class     :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class DriversLicense < ApplicationRecord

  extend Enumerize
  include LicenseUploader[:license]

  belongs_to :driver_profile

  enumerize :license_class, in: I18n.t("enumerize.license_class").keys# frozen_string_literal: true

  validates :license_data, :license_number, :exp_date, :license_class, presence: true

end

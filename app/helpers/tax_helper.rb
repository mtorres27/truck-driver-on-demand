# frozen_string_literal: true

module TaxHelper

  PROVINCES = {
    "ON" => 0.13,
    "AB" => 0.05,
    "BC" => 0.12,
    "MB" => 0.13,
    "NB" => 0.15,
    "NS" => 0.15,
    "QC" => 0.14975,
    "SK" => 0.11,
    "NL" => 0.15,
    "NU" => 0.05,
    "PE" => 0.15,
    "YT" => 0.05,
    "NT" => 0.05,
  }.freeze

  def province_tax(province)
    return 0 unless PROVINCES.key?(province)

    PROVINCES[province]
  end

end

module TaxHelper
  PROVINCES = {
    'ON' => 13,
    'AB' => 5,
    'BC' => 12,
    'MB' => 13,
    'NB' => 15,
    'NS' => 15,
    'QC' => 14.975,
    'SK' => 11,
    'NL' => 15,
    'NU' => 5,
    'PE' => 15,
    'YT' => 5,
    'NT' => 5
  }

  def province_tax(province)
    return 0 unless FIELDS.key?(field)
    PROVINCES[province]
  end
end

module StripeHelper
  FIELDS = {
    'external_account' => 'Account',
    'legal_entity.address.city' => 'City',
    'legal_entity.address.line1' => 'Line 1',
    'legal_entity.address.postal_code' => 'Postal Code',
    'legal_entity.address.state' => 'State',
    'legal_entity.dob.day' => 'Day',
    'legal_entity.dob.month' => 'Month',
    'legal_entity.dob.year' => 'Year',
    'legal_entity.first_name' => 'First Name',
    'legal_entity.last_name' => 'Last Name',
    'legal_entity.personal_id_number' => 'ID Number',
    'legal_entity.business_name' => 'Company Name',
    'legal_entity.business_tax_id' => 'Company Tax ID',
  }

  def pretty_name(field)
    return field unless FIELDS.key?(field)
    FIELDS[field]
  end
end

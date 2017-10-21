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
    'legal_entity.verification.document' => 'Verification Document',
    'legal_entity.personal_address.city' => 'Personal address city',
    'legal_entity.personal_address.line1'  => 'Personal Addres Line 1',
    'legal_entity.personal_address.postal_code'  => 'Personal Postal Code',
    'legal_entity.additional_owners'  => 'Additional Owners',
    'legal_entity.personal_address.state' => 'Personal Address State'
  }

  def pretty_name(field)
    return field unless FIELDS.key?(field)
    FIELDS[field]
  end
end

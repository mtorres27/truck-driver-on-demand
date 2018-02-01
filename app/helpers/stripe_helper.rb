module StripeHelper
  FIELDS = {
    'external_account' => 'Account',
    'legal_entity.first_name' => {'title' => 'First Name' , 'placeholder' => 'Enter your First Name'},
    'legal_entity.last_name' => {'title' => 'Last Name' , 'placeholder' => 'Enter your Last Name'},
    'legal_entity.address.city' => {'title' => 'City' , 'placeholder' => 'Enter your City'},
    'legal_entity.address.line1' => {'title' => 'Address' , 'placeholder' => 'Enter your Street Address'},
    'legal_entity.address.postal_code' => {'title' => 'Postal/ZIP Code' , 'placeholder' => 'Enter your Postal Code'},
    'legal_entity.address.state' => {'title' => 'State/Province/County' , 'placeholder' => 'State/Province/County'},
    'legal_entity.dob.day' => {'title' => 'Date of Birth' , 'placeholder' => 'DD'},
    'legal_entity.dob.month' => {'title' => 'Month' , 'placeholder' => 'MM'},
    'legal_entity.dob.year' => {'title' => 'Year' , 'placeholder' => 'YYYY'},
    'legal_entity.personal_id_number' => {'title' => 'Personal ID' , 'placeholder' => 'Enter your PID', 'helpertext'=>'Your Personal ID Number is a government issued ID such as a SIN or SSN. Please note this information is used by Stripe—our payments gateway—to verify your identity. To understand how this data is used please read Stripe\'s Privacy Policy found here stripe.com/ca/privacy'},
    'legal_entity.business_name' => {'title' => 'Registered Business Name' , 'placeholder' => 'Enter your Business Name'},
    'legal_entity.business_tax_id' => {'title' => 'Business Tax ID' , 'placeholder' => 'Business Tax ID'},
    'legal_entity.verification.document' => {'title' => 'Verification Document' , 'placeholder' => 'Business Tax ID', 'helpertext'=>'The Verification Document is any government issued document that identifies you, such as a Passport, Permanent Resident Card or Drivers License. Upload a .jpg or .png version of this document.'},
    'legal_entity.personal_address.city' => {'title' => 'Home City' , 'placeholder' => 'Enter your City'},
    'legal_entity.personal_address.line1' => {'title' => 'Home Address' , 'placeholder' => 'Enter your Address'},
    'legal_entity.personal_address.postal_code' => {'title' => 'Postal/ZIP Code' , 'placeholder' => 'Enter your Postal/ZIP Code'},
    'legal_entity.personal_address.state' => {'title' => 'Home State/Province/County' , 'placeholder' => 'Home State/Province/County'},
    'legal_entity.additional_owners' => {'title' => 'Additional Owners' , 'placeholder' => 'Enter any Additional Owners'},
  }

  def pretty_name(field, type='title')
    return field unless FIELDS.key?(field)
    FIELDS[field][type]
  end

  def field_helper? (field)
    FIELDS[field].present? && FIELDS[field].key?('helpertext')
  end
end

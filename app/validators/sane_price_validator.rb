class SanePriceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value && !value.is_a?(String) && value > 0 && value < 1000000
      record.errors[attribute] << (options[:message] || "must be between $0 and $1,000,000")
    end
  end
end

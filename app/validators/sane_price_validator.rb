# frozen_string_literal: true

class SanePriceValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    return if value && !value.is_a?(String) && value.positive? && value < 1_000_000

    record.errors[attribute] << (options[:message] || "must be between $0 and $1,000,000")
  end

end

# == Schema Information
#
# Table name: currency_rates
#
#  id         :integer          not null, primary key
#  currency   :string
#  country    :string
#  rate       :decimal(10, 2)   not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CurrencyRate < ApplicationRecord
end
class CurrencyExchange
  require 'money/bank/open_exchange_rates_bank'

  def self.dollars_to_currency(dollars, currency)
    oxr = Money::Bank::OpenExchangeRatesBank.new
    oxr.app_id = Rails.application.secrets.open_exchange_rates_api_key
    oxr.update_rates
    dollars * oxr.get_rate('USD', currency.upcase)
  end

  def self.currency_to_dollars(amount, currency)
    oxr = Money::Bank::OpenExchangeRatesBank.new
    oxr.app_id = Rails.application.secrets.open_exchange_rates_api_key
    oxr.update_rates
    amount / oxr.get_rate('USD', currency.upcase)
  end
end
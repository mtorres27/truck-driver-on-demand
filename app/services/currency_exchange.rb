class CurrencyExchange
  def self.dollars_to_currency(dollars, currency)
    currency_rate = CurrencyRate.where('currency = ?', currency).first
    rate = currency_rate.rate.nil? ?  1 : currency_rate.rate
    dollars * rate
  end

  def self.currency_to_dollars(amount, currency)
    currency_rate = CurrencyRate.where('currency = ?', currency).first
    rate = currency_rate.rate.nil? ?  1 : currency_rate.rate
    amount / rate
  end
end
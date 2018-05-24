class CurrencyExchange
  def self.dollars_to_currency(amount, currency)
    currency_rate = CurrencyRate.where('currency = ?', currency).first
    rate = currency_rate.rate.nil? ?  1 : currency_rate.rate
    amount * rate
  end

  def self.currency_to_dollars(amount, currency)
    currency_rate = CurrencyRate.where('currency = ?', currency).first
    rate = currency_rate.rate.nil? ?  1 : currency_rate.rate
    amount / rate
  end

  def self.get_currency_rate(currency)
    currency_rate = CurrencyRate.where('currency = ?', currency).first
    currency_rate.rate.nil? ?  1 : currency_rate.rate
  end
end
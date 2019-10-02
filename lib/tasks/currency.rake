namespace :currency do
  require 'net/http'

  desc 'Update currency rates'
  task refresh: :environment do
    currency_count = CurrencyRate.count
    if currency_count.zero?
      countries = Stripe::CountrySpec.list(limit: 100)
      countries.data.each do |c|
        currency_rate = CurrencyRate.new()
        currency_rate.country = c.id
        currency_rate.currency = c.default_currency
        currency_rate.rate = 1
        currency_rate.save
      end
    end
    currencies = CurrencyRate.distinct.pluck(:currency)
    countries_str = currencies.join(',')
    puts 'http://data.fixer.io/api/latest?access_key='+ENV['fixer_api_key']+'&base=CAD&symbols='+countries_str
    # TODO: Change base currency to USD (needs paid account)
    url = URI.parse('http://data.fixer.io/api/latest?access_key='+ENV['fixer_api_key']+'&base=CAD&symbols='+countries_str)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
    result = JSON.parse(res.body)
    puts result
    if result["success"] == true
      result["rates"].each do |curr, rate|
        CurrencyRate.where(currency: curr.downcase).update_all(rate: rate, updated_at: Time.now)
      end
    end
    puts CurrencyRate.all

    # {"success":true,
    # "timestamp":1521464669,
    # "base":"EUR",
    # "date":"2018-03-19",
    # "rates":{
      # "SEK":10.083685,
      # "NZD":1.705691,
      # "USD":1.230922,
      # "DKK":7.450067,
      # "EUR":1,
      # "GBP":0.87505,
      # "CAD":1.60919,
      # "JPY":130.736183,
      # "SGD":1.622244,
      # "CHF":1.171713,
      # "NOK":9.521117,
      # "HKD":9.653785,
      # "AUD":1.597985
    # }
    # }

  end
end
module AvalaraTool
  def initialize

  end

  def self.test
    AvaTax.configure do |config|
      begin
        config.endpoint = credentials['endpoint']
        config.username = credentials['username']
        config.password = credentials['password']
      rescue
        config.endpoint = 'https://sandbox-rest.avatax.com'
        config.username = "khodeir.mt@gmail.com"
        config.password = "4B6A78769D"
      end
    end

    @client = AvaTax::Client.new(:logger => true)
    createTransactionModel = {
      type: 'SalesInvoice',
      companyCode: 'DEFAULT',
      date: '2017-11-15',
      customerCode: 'ABC',
      "addresses": {
        "ShipFrom": {
          "line1": "1040 Grant Rd #310",
          "city": "Mountain View",
          "region": "CA",
          "country": "US",
          "postalCode": "94040"
        },
        "ShipTo": {
          "line1": "100 Market Street",
          "city": "San Francisco",
          "region": "CA",
          "country": "US",
          "postalCode": "94105"
        }
      },
      lines: [{amount: 100}]
    }
    res = @client.create_transaction(createTransactionModel)
    Rails.logger.debug res['totalTax']
  end

end

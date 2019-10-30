# frozen_string_literal: true

# TODO: Do we use this module?
module AvalaraTool

  def initialize; end

  # rubocop:disable Metrics/MethodLength
  def self.calculate(from_address, to_address, lines)
    AvaTax.configure do |config|
      config.endpoint = credentials["endpoint"]
      config.username = credentials["username"]
      config.password = credentials["password"]
    rescue StandardError
      # TODO: Use this as default credentials on secrets file
      config.endpoint = "https://sandbox-rest.avatax.com"
      config.username = "khodeir.mt@gmail.com"
      config.password = "4B6A78769D"
    end

    @client = AvaTax::Client.new(logger: true)
    create_transaction_model = {
      type: "SalesInvoice",
      companyCode: "DEFAULT",
      date: "2017-11-15",
      customerCode: "ABC",
      "addresses": {
        "ShipFrom": from_address,
        "ShipTo": to_address,
      },
      lines: lines,
    }
    res = @client.create_transaction(create_transaction_model)
    Rails.logger.debug res["totalTax"]
  end
  # rubocop:enable Metrics/MethodLength

end

module TaxjarTool
  def initialize

  end

  def self.calculate(from_address, to_address, lines)
    @client = Taxjar::Client.new(api_key: 'd9cc248608886470db9c56ce8fe8646a')
    @client.tax_for_order({
      :to_street => to_address[:line1],
      :to_country => to_address[:country],
      :to_zip => to_address[:postalCode],
      :to_city => to_address[:city],
      :to_state => to_address[:state],
      :from_street => from_address[:line1],
      :from_country => from_address[:country],
      :from_zip => from_address[:postalCode],
      :from_city => from_address[:city],
      :from_state => from_address[:state],
      :amount => 15,
      :shipping => 0,
      # :nexus_addresses => [{:address_id => 1,
      #                       :country => 'US',
      #                       :zip => '93101',
      #                       :state => 'CA',
      #                       :city => 'Santa Barbara',
      #                       :street => '1218 State St.'}],
      :line_items => [
                       {
                         :quantity => 1,
                         :unit_price => 15,
                         :product_tax_code => 20010
                       },
                        {
                          :quantity => 2,
                          :unit_price => 30,
                          :product_tax_code => 20010
                        }
                      ]
  })
  end
end

# require_relative 'fedex3'

# # Instantiate the FedexRates class
# fedex_rates = FedexApi.new

# # Call the get_rates method and print out the results
# rates = fedex_rates.rate_request
# puts "Shipping Rates:"
# rates.each do |rate|
#   puts "#{rate[:service_type]}: $#{rate[:total_net_charge]} (#{rate[:delivery_days]} days)"
# end

require_relative 'fedex3'

fedex_api = FedexApi.new
response = fedex_api.rate_request(
  from: {
    city: "AUSTIN",
    state: "TX",
    postal_code: "73301",
    country_code: "US"
  },
  to: {
    city: "COLLIERVILLE",
    state: "TN",
    postal_code: "38017",
    country_code: "US"
  },
  weight: 70,
  length: 12,
  width: 12,
  height: 12,
  services: ["FEDEX_EXPRESS_SAVER"]
)

rates = response[:rates]
if rates
  puts "Shipping Rates:"
  rates.each do |service_type, total_price|
    puts "#{service_type}: #{total_price}"
  end
else
  puts "Error: #{response[:error_message]}"
end

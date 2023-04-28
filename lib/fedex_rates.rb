require "net/http"
require "uri"
require "nokogiri"
require 'date'

class FedexApi
  attr_reader :error_message

  def initialize
    @uri = URI.parse("https://wsbeta.fedex.com/xml")
    @key = "bkjIgUhxdghtLw9L"
    @password = "6p8oOccHmDwuJZCyJs44wQ0Iw"
    @account_number = "510087720"
    @meter_number = "119238439"
  end

  def rate_request(from:, to:, weight:, length:, width:, height:, services:)
    request_xml = build_request(from: from, to: to, weight: weight, length: length, width: width, height: height, services: services)

    request = Net::HTTP::Post.new(@uri)
    request.content_type = "text/xml"
    request.body = request_xml

    puts request_xml
    response = Net::HTTP.start(@uri.hostname, @uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    puts response.body
    parse_response(response.body) || {}
  end

  private

  def build_request(from:, to:, weight:, length:, width:, height:, services:)
    xml = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
          xml.RateRequest('xmlns' => 'http://fedex.com/ws/rate/v31') {
            xml.WebAuthenticationDetail {
            #   xml.ParentCredential {
            #     xml.Key(@key)
            #     xml.Password(@password)
            #   }
              xml.UserCredential {
                xml.Key(@key)
                xml.Password(@password)
              }
            }
            xml.ClientDetail {
              xml.AccountNumber(@account_number)
              xml.MeterNumber(@meter_number)
              xml.SoftwareId("WSXI")
            }
            xml.TransactionDetail {
              xml.CustomerTransactionId("RateRequest_v21")
            }
            xml.Version {
              xml.ServiceId("crs")
              xml.Major("31")
              xml.Intermediate("0")
              xml.Minor("0")
            }
            xml.RequestedShipment {
              xml.ShipTimestamp(DateTime.now.new_offset('-06:00').strftime('%Y-%m-%dT%H:%M:%S%:z'))
              xml.DropoffType("REGULAR_PICKUP")
              xml.ServiceType("PRIORITY_OVERNIGHT")
              xml.PackagingType("YOUR_PACKAGING")
              xml.Shipper {
                xml.AccountNumber("${#TestSuite#AccountNumber}")
                xml.Contact {
                  xml.CompanyName("FedEx-WAPI")
                  xml.PhoneNumber("1234567890")
                }
                xml.Address {
                  xml.StreetLines("SN2000 Test Meter 8")
                  xml.StreetLines("10 Fedex Parkway")
                  xml.City("AUSTIN")
                  xml.StateOrProvinceCode("TX")
                  xml.PostalCode("73301")
                  xml.CountryCode("US")
                }
              }
              xml.Recipient {
                xml.AccountNumber("${#TestSuite#AccountNumber}")
                xml.Contact {
                  xml.PersonName("Recipient Contact")
                  xml.PhoneNumber("1234567890")
                }
                xml.Address {
                  xml.StreetLines("SN2000 Test Meter 8")
                  xml.StreetLines("10 Fedex Parkway")
                  xml.City("COLLIERVILLE")
                  xml.StateOrProvinceCode("TN")
                  xml.PostalCode("38017")
                  xml.CountryCode("US")
                }
              }
              xml.ShippingChargesPayment {
                xml.PaymentType("SENDER")
                xml.Payor {
                  xml.ResponsibleParty {
                    xml.AccountNumber("${#TestSuite#AccountNumber}")
                    xml.Tins {
                      xml.TinType("BUSINESS_STATE")
                      xml.Number("123456")
                    }
                  }
                }
              }
              xml.RateRequestTypes("LIST")
              xml.PackageCount("1")
              xml.RequestedPackageLineItems {
                xml.SequenceNumber("1")
                xml.GroupNumber("1")
                xml.GroupPackageCount("1")
                xml.Weight {
                  xml.Units("LB")
                  xml.Value("70.0")
                }
                xml.Dimensions {
                  xml.Length("12")
                  xml.Width("12")
                  xml.Height("12")
                  xml.Units("IN")
                }
                xml.ContentRecords {
                  xml.PartNumber("123445")
                  xml.ItemNumber("kjdjalsro1262739827")
                  xml.ReceivedQuantity("12")
                  xml.Description("ContentDescription")
                }
              }
            }
          }
        end
        

    xml.to_xml
  end

  def parse_response(response_body)
    response = Nokogiri::XML(response_body)

    # Check for errors
    error_node = response.at_xpath("//Error")
    if error_node
        @error_message = error_node.at_xpath("Message").text
        return nil
    end

    # Extract rates
        rate_nodes = response.xpath("//RatedShipment")
        rates = {}
        rate_nodes.each do |rate_node|
            rate_type = rate_node.at_xpath("ServiceType").text
            total_price = rate_node.at_xpath("TotalNetCharge/Amount").text.to_f
            puts "Service Type: #{rate_type}, Total Net Charge: #{total_price}"
            rates[rate_type] = total_price
        end

        #Print rates
        puts "Shipping Rates:"
        rates.each do |rate_type, total_price|
        puts "#{rate_type}: $#{total_price}"
        end

        return rates
    end

    xml = FedexApi.new
    xml = xml.rate_request(from: "sender address", to: "recipient address", weight: 0.3, length: 30, width: 20, height: 10, services: "FEDEX_EXPRESS_SAVER")
    doc = Nokogiri::XML(xml)
    puts doc.errors.empty? ? "XML válido" : "XML inválido"
    puts "---------"
    puts xml.to_s

end


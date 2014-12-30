#require "hipay/version"
require 'savon'

module Hipay

  TEST_PLATFORM = "test-"

  def self.call_api(ressource, operation, plateform, message = nil)
    test_url = (plateform ? TEST_PLATFORM : "")
    client = Savon.client(wsdl: "https://#{test_url}ws.hipay.com/soap/#{ressource}?wsdl", ssl_version: :TLSv1)
    response = client.call(operation, message: message)
    return response.body
  end

  class Payment

    def initialize(wsLogin, wsPassword, websiteId, categoryId, platform = false, wsSubAccountLogin = nil)
      @wsLogin = wsLogin
      @wsPassword = wsPassword
      @websiteId = websiteId
      @categoryId = categoryId
      @wsSubAccountLogin = wsSubAccountLogin
      @plateform = platform
    end

    def generate(amount, customerIpAddress,  urlCallback, currency = "EUR", rating = "ALL", locale = "en_GB",
                 manualCapture = 0, executionDate = '', description = 'payment', customerEmail = nil,
                 urlAccept = nil, urlDecline = nil, urlCancel = nil, urlLogo = nil,
                 merchantReference = nil, merchantComment = nil, emailCallback = nil, freedata = nil)

      operation = :generate
      parameters = build_basic_request
      parameters[:currency] = currency
      parameters[:amount] = amount
      parameters[:rating] = rating
      parameters[:locale] = locale
      parameters[:customerIpAddress] = customerIpAddress
      parameters[:manualCapture] = manualCapture
      parameters[:executionDate] = executionDate
      parameters[:description] = description
      parameters[:urlCallback] = urlCallback

      if !customerEmail.nil?
        parameters[:customerEmail] = customerEmail
      end
      if !urlAccept.nil?
        parameters[:urlAccept] = urlAccept
      end
      if !urlCancel.nil?
      parameters[:urlCancel] = urlCancel
      end
      if !urlDecline.nil?
      parameters[:urlDecline] = urlDecline
      end
      if !urlLogo.nil?
      parameters[:urlLogo] = urlLogo
      end
      if !merchantReference.nil?
      parameters[:merchantReference] = merchantReference
      end
      if !merchantComment.nil?
      parameters[:merchantComment] = merchantComment
      end
      if !emailCallback.nil?
      parameters[:emailCallback] = emailCallback
      end
      if !freedata.nil?
      parameters[:freedata] = freedata
      end

      response = Hipay::call_api("payment-v2", operation, @plateform, {parameters: parameters})
    end

    def build_basic_request()
      { wsLogin: @wsLogin, wsPassword: @wsPassword, websiteId: @websiteId, categoryId: @categoryId }
    end

  end

  class Transaction

  end

  class Refund

  end

  class BussinessLines

  end

  class WebsiteTopics

  end

end


#payment = Hipay::Payment.new("XXXXXXXXX", "XXXXXXXXXXXX", "XXXX", "XXX", true)
#gepayment.generate(10, "192.168.1.1", "http://www.site.fr/callback.php"
#require "hipay/version"
require 'savon'

module Hipay

  TEST_PLATFORM = "test-"

  def self.call_api(ressource, operation, test, message = nil)
    test_url = (test ? TEST_PLATFORM : "")
    client = Savon.client(wsdl: "https://#{test_url}ws.hipay.com/soap/#{ressource}?wsdl", ssl_version: :TLSv1)
    response = client.call(operation, message: message)
    return response.body
  end

  class Payment

    def initialize(wsLogin, wsPassword, websiteId, categoryId, test: false)
      @wsLogin = wsLogin
      @wsPassword = wsPassword
      @websiteId = websiteId
      @categoryId = categoryId
      @test = test
    end

    def generate(amount, customerIpAddress,  urlCallback, currency: "EUR", rating: "ALL", locale: "en_GB",
                 manualCapture: 0, executionDate: '', description: 'payment', customerEmail: nil,
                 urlAccept: nil, urlDecline: nil, urlCancel: nil, urlLogo: nil,
                 merchantReference: nil, merchantComment: nil, emailCallback: nil, freedata: nil)

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

      Hipay::call_api("payment-v2", operation, @test, {parameters: parameters})[:generate_response][:generate_result]
    end

    def build_basic_request()
      { wsLogin: @wsLogin, wsPassword: @wsPassword, websiteId: @websiteId, categoryId: @categoryId }
    end

  end

  class Refund

    def initialize(wsLogin, wsPassword, websiteId, test: false)
      @wsLogin = wsLogin
      @wsPassword = wsPassword
      @websiteId = websiteId
      @test = test
    end

    def card(transactionPublicId, currency, amount)
      @transactionPublicId = transactionPublicId
      operation = :card
      parameters = build_basic_request

      if !amount.nil?
          parameters[:amount] = amount
      end
      if !currency
        parameters[:currency] = currency
      end
      Hipay::call_api("refund-v2", operation, @test, {parameters: parameters})[:card_response][:card_result]
    end

    def account(transactionPublicId, currency, amount)
      @transactionPublicId = transactionPublicId
      operation = :account
      parameters = build_basic_request

      if !amount.nil?
        parameters[:amount] = amount
      end
      if !currency
        parameters[:currency] = currency
      end
      Hipay::call_api("refund-v2", operation, @test, { parameters: parameters })[:account_response][:account_result]
    end

    def build_basic_request()
      { wsLogin: @wsLogin, wsPassword: @wsPassword, websiteId: @websiteId, transactionPublicId: @transactionPublicId }
    end

  end

  class Transaction

    def initialize(wsLogin, wsPassword, test: false)
      @wsLogin = wsLogin
      @wsPassword = wsPassword
      @test = test
    end

    def confirm(transactionPublicId)
      @transactionPublicId = transactionPublicId
      operation = :confirm
      parameters = build_basic_request
      Hipay::call_api("transaction-v2", operation, @test, { parameters: parameters })[:confirm_response][:confirm_result]
    end

    def cancel(transactionPublicId)
      @transactionPublicId = transactionPublicId
      operation = :cancel
      parameters = build_basic_request
      Hipay::call_api("transaction-v2", operation, @test, { parameters: parameters })[:cancel_response][:cancel_result]
    end

    def build_basic_request
      { wsLogin: @wsLogin, wsPassword: @wsPassword, transactionPublicId: @transactionPublicId }
    end

  end

  class BusinessLines

    def initialize(wsLogin, wsPassword, test: false)
      @wsLogin = wsLogin
      @wsPassword = wsPassword
      @test = test
    end

    def get(locale)
      @locale = locale
      operation = :get
      parameters = build_basic_request
      Hipay::call_api("business-lines-v2", operation, @test, { parameters: parameters })[:get_response][:get_result]
    end

    def build_basic_request
      { wsLogin: @wsLogin, wsPassword: @wsPassword, locale: @locale }
    end
  end

  class WebsiteTopics

    def initialize(wsLogin, wsPassword, test: false)
      @wsLogin = wsLogin
      @wsPassword = wsPassword
      @test = test
    end

    def get(locale, businessLineId)
      @locale = locale
      @businessLineId = businessLineId
      operation = :get
      parameters = build_basic_request
      Hipay::call_api("website-topics-v2", operation, @test, { parameters: parameters })[:get_response][:get_result]
    end

    def build_basic_request
      { wsLogin: @wsLogin, wsPassword: @wsPassword, locale: @locale, businessLineId: @businessLineId }
    end
  end

end

#payment = Hipay::Payment.new("XXXXXXXXX", "XXXXXXXXXXXX", "XXXX", "XXX", true)
#payment.generate(10, "192.168.1.1", "http://www.site.fr/callback.php"
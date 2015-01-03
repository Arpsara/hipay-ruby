# Hipay

This gem works with an Hipay webservice account
https://www.hipaywallet.com/

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hipay'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hipay

The gem consists of the following functionality:
* `Payment`
* `Refund`
* `Transaction`
* `BusinessLines`
* `WebTopics`

The main module is called `Hipay`

##`Payment` module

An instance of the `Payment` class needs to be initialized before it can be used.

Constructor params:

```
wsLogin: string
wsPassword: string
websiteId: string
categoryId: string
test: boolean
```

`test` boolean is to perform operations on test platform, default is false

Usage:
```ruby
require 'hipay'

payment = Hipay::Payment.new(wsLogin, wsPassword, websiteId, categoryId)
```

to get the category id please visit
Production platform:
https://payment.hipay.com/order/list-categories/id/[production websiteID]
Stage platform:
https://test-payment.hipay.com/order/list-categories/id/[stage websiteID]

####`generate`
Generate a new payment url. Returns a payment url, code status and message.

Params:
```
amount: int - The total order amount. Sum of the items purchased, +shipping fee (if present) +tax fee (if present).
customerIpAddress: string - The IP address of your customer making a purchase.
urlCallback: string - The URL to send back information update database.
currency: string - 3 chars ISO 4217, default EUR
rating: string - Age category of your order ("+12", "+16", "+18", "ALL"), default "ALL"
locale: string - Locale for displaying information in payment page, default "en_GB"
manualCapture: int - How you want to process the payment, default 0
* 0: indicates transaction is sent for authorization, and if approved, is automatically submitted for capture.
* 1: indicates this transaction is sent for authorization only. The transaction will not be sent for settlement until the Merchant submits the transaction for capture manually.
executionDate: string - Date and time of execution of the payment (Y-m-dTH:i:s)
description: string - The order short description
customerEmail: string - (optional) The customer's e-mail address
urlAccept: string - (optional)
urlDecline: string - (optional)
urlCancel: string - (optional)
urlLogo: string - (optional) This URL of your logo for the payment page (HTTPS)
merchantReference: string - (optional) Merchants’ order reference
merchantComment: string - (optional) Merchants’ comment concerning the order
emailCallback: string - (optional) Email used by HiPay Wallet to post operation notifications
freedata: string - (optional) Custom data
<freeData>
<item>
 <key>keyOne</key>
 <value>ValueOne</value>
</item>
<item>
 <key>keyTwo</key>
 <value>ValueTwo</value>
</item>
</freeData>
```

Usage:
```ruby
payment.generate(100, "192.168.1.1", "http://www.site.com/callback", "2014-12-25T10:57:55", "order#123 - books")
```

## Contributing

1. Fork it ( https://github.com/UgoMare/hipay/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

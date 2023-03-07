require "active_record/railtie" # Sc: I added this because without it rspec complains about ActiveRecord::Base
require_relative "simple_forex/version"


  # # SimpleForex

  # This ruby gem lets you fetch exchange rates for ~170 currencies (a total of ~14,000 imputed currency pairs) for free, on an hourly frequently (sufficient for most, but not all, use cases), and takes only about 5 minutes to set up. 

  # The usage instructions below show how to create a currencies table, run a rake task to update the exchange rates, and use `convert()` to convert between currencies inside your application. Total time to implementation should be ~5 minutes. 


  # ## Installation

  # Install the gem in one of the usual ways:

  #   bundle add simple_forex

  #   gem install simple_forex


  # ## Usage

  # ### Create a currencies table 

  # Use the included generator will make a currencies table migration: 

  # ```bash
  # rails generate simple_forex
  # ```

  # Then run the migration: 

  # ```
  # rake db:migrate
  # ```

  # ### Fetch exchange rates 

  # Create a [free API key](https://openexchangerates.org/signup/free), open credentials.yml (`EDITOR="vim" rails credentials:edit`) and add the API key to credentials.yml like so:

  # ```
  # # config/credentials.yml.enc

  # simple_forex:
  # openexchangerates_key: 1234abcd
  # ```

  # Run this rate task to retrieve currencies and store them in the currencies table:

  # ```bash
  # rake simple_forex:fetch_rates
  # ```

  # View the exchange rate data in the rails console with `Currency.last`:

  # ```
  # => #<SimpleForex::Currency:0x000000013c4bae78
  # id: 1,
  # blob:
  # {"base"=>"USD",
  #   "rates"=>
  #   {"AED"=>"3.67286",
  #     "AFN"=>"89.49999",
  #     "ALL"=>"108.164235",
  #     "AMD"=>"388.147964",
  #     "ANG"=>"1.798456",
  #     "AOA"=>"503.891",
  #     "ARS"=>"198.1831",
  #     "AUD"=>"1.485125",

  #     ...
      
  #     "XOF"=>"617.115134",
  #     "XPD"=>"0.00069861",
  #     "XPF"=>"112.265627",
  #     "XPT"=>"0.00103175",
  #     "YER"=>"250.300106",
  #     "ZAR"=>"18.23512",
  #     "ZMW"=>"19.934751",
  #     "ZWL"=>"322.0"},
  #   "license"=>"https://openexchangerates.org/license",
  #   "timestamp"=>1678096800,
  #   "disclaimer"=>"Usage subject to terms: https://openexchangerates.org/terms"},
  # created_at: Mon, 06 Mar 2023 10:43:54 UTC +00:00,
  # updated_at: Mon, 06 Mar 2023 10:43:54 UTC +00:00>
  # ```


  # **Optional**

  # Schedule the `simple_forex:fetch_rates` rake task to run at the frequency you require. 

  # Tip: open exchange rates's free API gives 1000 calls monthly, and there are ~700 hours in month, so you safely run it hourly while staying within the free limit.

module SimpleForex
  class Error < StandardError; end

  # From: https://stackoverflow.com/a/31701809/5783745
  # Otherwise after the migration you get Currency.count # uninitialized constant Currency (NameError)
  class Currency < ActiveRecord::Base
  end

  
  
  def currency_exchange_rate(from, to)

    currencies = Currency.last.blob

    # Tests: 
    # currency_exchange_rate("aud", "gbp") # 0.54
    # currency_exchange_rate("GBP", "AUD") # 1.832
    # currency_exchange_rate("USD", "AUD") # 1.29
    # currency_exchange_rate("AUD", "usd") # 0.77

    # The open exchange rate API uses UPPER case (unlike stripe and some other platforms)
    from = from.upcase
    to = to.upcase

    error_message = """
    The currency %{currency_code} is not a valid currency code. 
    Run `Currency.last.blob[\"rates\"].keys` to view 
    available currencies. 
    """
    # from = "AUDz"
    # error_message % {currency_code: from}

    raise error_message % {currency_code: from} unless currencies["rates"].keys.include? from
    raise error_message % {currency_code: to} unless currencies["rates"].keys.include? to


    usd_to_from = currencies['rates'][from].to_d
    usd_to_to = currencies['rates'][to].to_d
    rate = usd_to_to / usd_to_from
    # This converts 1 AUD to GPD (gives 0.54585)
    # R example: rates$rates$GBP / rates$rates$AUD 
    # Ruby: currency['rates']['GBP'].to_d / currency['rates']['AUD'].to_d

    return rate


  end



  def convert(amount, from_currency, to_currency)
    # Examples:
    # convert(100, "aud", "gbp") # 54.585
    # convert(100, "gbp", "aud") # 183.2
    # convert(100, "usd", "aud") # 129.0
    # convert(100, "aud", "usd") # 77.0
    begin
      rate = currency_exchange_rate(from_currency, to_currency)
    rescue => exception
       $stderr.puts "Error: #{exception} - \n\nYou could be seeing this error if you forgot to setup the database and fetch currency data. 
       \nDid you forget to run `rails g simple_forex:install`, `rake db:migrate` or `rake simple_forex:fetch_rates`?
       \nSee documentation for more information: https://github.com/stevecondylios/SimpleForex\n\n"
    end
      
    converted_amount = amount * rate
    return converted_amount 
  end



  def all_currencies
    # Acquired via Currency.last.blob['rates'].keys
    ["AED",   "AFN",   "ALL",   "AMD",   "ANG",   "AOA",   "ARS",   "AUD",   "AWG",   "AZN",   "BAM",   "BBD",   "BDT",   "BGN",   "BHD",   "BIF",   "BMD",   "BND",   "BOB",   "BRL",   "BSD",   "BTC",   "BTN",   "BWP",   "BYN",   "BZD",   "CAD",   "CDF",   "CHF",   "CLF",   "CLP",   "CNH",   "CNY",   "COP",   "CRC",   "CUC",   "CUP",   "CVE",   "CZK",   "DJF",   "DKK",   "DOP",   "DZD",   "EGP",   "ERN",   "ETB",   "EUR",   "FJD",   "FKP",   "GBP",   "GEL",   "GGP",   "GHS",   "GIP",   "GMD",   "GNF",   "GTQ",   "GYD",   "HKD",   "HNL",   "HRK",   "HTG",   "HUF",   "IDR",   "ILS",   "IMP",   "INR",   "IQD",   "IRR",   "ISK",   "JEP",   "JMD",   "JOD",   "JPY",   "KES",   "KGS",   "KHR",   "KMF",   "KPW",   "KRW",   "KWD",   "KYD",   "KZT",   "LAK",   "LBP",   "LKR",   "LRD",   "LSL",   "LYD",   "MAD",   "MDL",   "MGA",   "MKD",   "MMK",   "MNT",   "MOP",   "MRU",   "MUR",   "MVR",   "MWK",   "MXN",   "MYR",   "MZN",   "NAD",   "NGN",   "NIO",   "NOK",   "NPR",   "NZD",   "OMR",   "PAB",   "PEN",   "PGK",   "PHP",   "PKR",   "PLN",   "PYG",   "QAR",   "RON",   "RSD",   "RUB",   "RWF",   "SAR",   "SBD",   "SCR",   "SDG",   "SEK",   "SGD",   "SHP",   "SLL",   "SOS",   "SRD",   "SSP",   "STD",   "STN",   "SVC",   "SYP",   "SZL",   "THB",   "TJS",   "TMT",   "TND",   "TOP",   "TRY",   "TTD",   "TWD",   "TZS",   "UAH",   "UGX",   "USD",   "UYU",   "UZS",   "VES",   "VND",   "VUV",   "WST",   "XAF",   "XAG",   "XAU",   "XCD",   "XDR",   "XOF",   "XPD",   "XPF",   "XPT",   "YER",   "ZAR",   "ZMW",   "ZWL"] 
  end




 def some_currencies
   ["AUD", "CAD", "EUR", "GBP", "HKD", "NZD", "SGD", "USD"]
 end




 # Required for rake files
# From here: https://gist.github.com/ntamvl/7a6658b4cd82d6fbd15434f0a9953411#integrate-our-gem-with-rails-apps
# require 'railtie' if defined?(Rails)




end # This is the end for the module





# sc: this goes at the end so the module gets loaded when require 'simple_forex' is called
include SimpleForex




require "simple_forex/railtie" if defined?(Rails::Railtie)

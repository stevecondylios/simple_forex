# frozen_string_literal: true

require "active_record/railtie" # Sc: I added this because without it rspec complains about ActiveRecord::Base
require_relative "simple_forex/version"

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

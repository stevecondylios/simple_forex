# SimpleForex

You already know how to convert between currencies and all you need to do is get the exchange rate data.

And that part's easy, right..?

This gem lets you fetch exchange rates for ~170 currencies (a total of ~14,000 imputed currency pairs) for free, on an hourly frequently (sufficient for most, but not all, use cases), and takes only about 5 minutes to set up. 

The usage instructions below show how to create a currencies table, run a rake task to update the exchange rates, and use `convert()` to convert between currencies inside your application.


## Installation

Install the gem in one of the usual ways:

```bash
bundle add simple_forex

gem install simple_forex
```

## Usage

### Create a currencies table 

Use the included generator will make a currencies table migration: 

```bash
rails generate simple_forex
```

Then run the migration: 

```
rake db:migrate
```

### Fetch exchange rates 

Create a [free API key](https://openexchangerates.org/signup/free), open credentials.yml (`EDITOR="vim" rails credentials:edit`) and add the API key to credentials.yml like so:

```
# config/credentials.yml.enc
simple_forex:
  openexchangerates_key: 1234abcd
```

Then, run this rate task to retrieve currencies and store them in the currencies table:

```bash
rake simple_forex:fetch_rates
```

View the exchange rate data in the rails console with `Currency.last`:

```
=> #<SimpleForex::Currency:0x000000013c4bae78
 id: 1,
 blob:
  {"base"=>"USD",
   "rates"=>
    {"AED"=>"3.67286",
     "AFN"=>"89.49999",
     "ALL"=>"108.164235",
     "AMD"=>"388.147964",
     "ANG"=>"1.798456",
     "AOA"=>"503.891",
     "ARS"=>"198.1831",
     "AUD"=>"1.485125",

     ...
     
     "XOF"=>"617.115134",
     "XPD"=>"0.00069861",
     "XPF"=>"112.265627",
     "XPT"=>"0.00103175",
     "YER"=>"250.300106",
     "ZAR"=>"18.23512",
     "ZMW"=>"19.934751",
     "ZWL"=>"322.0"},
   "license"=>"https://openexchangerates.org/license",
   "timestamp"=>1678096800,
   "disclaimer"=>"Usage subject to terms: https://openexchangerates.org/terms"},
 created_at: Mon, 06 Mar 2023 10:43:54 UTC +00:00,
 updated_at: Mon, 06 Mar 2023 10:43:54 UTC +00:00>
```


**Optional**

Schedule the `simple_forex:fetch_rates` rake task to run at the frequency you require. 

Tip: open exchange rates's free API gives 1000 calls monthly, and there are ~700 hours in month, so you safely run it hourly while staying within the free limit.


### Convert between currencies

Convert currencies by calling 

```ruby
require 'simple_forex'
convert(amount, from_currency, to_currency)
```

Example 

```ruby
require 'simple_forex'
convert(100, 'USD', 'EUR')
# => 0.939717e2
```

Note ruby decimals use scientific notation, evidenced by the `e` toward the end of the value.


## Requirements

This gem *probably* only works on Rails 6 and Rails 7 apps, and only those using a postgres database.

## Contributing

Bug reports and pull requests are very welcome at https://github.com/stevecondylios/simple_forex.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

# SimpleForex

The goal of the simple_forex gem is to help you quickly:

- Add a currencies table to your rails app
- Schedule the retrieval of up to date foreign exchange data (hourly from a free API)
- Convert between currencies

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add simple_forex
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install simple_forex
```

## Usage



### Add a currencies table to your rails app

After installing the gem, run this to add a currencies table to your rails app 

```bash
rails generate simple_forex
```

followed by 

```
rake db:migrate
```

### Run a rake task to update currencies 


Get a [free API key](https://openexchangerates.org/signup/free), open credentials.yml (`EDITOR="vim" rails credentials:edit`) and add the API key to credentials.yml like so:

```
# config/credentials.yml.enc
simple_forex:
  openexchangerates_key: 1234abcd
```

Then, run this to retrieve currencies in the currencies table:

```bash
rake simple_forex:fetch_rates
```

View the exchange rate data in the rails console with `Currency.last`.


### Schedule task to update currencies

**Optional**

Schedule the `simple_forex:fetch_rates` rake task to run at the frequency you require. 

Tip: open exchange rates's free API gives 1000 calls monthly, and there are ~700 hours in month, so you safely run it hourly while staying within the free limit.


### Convert between currencies

Convert currencies by calling 

```ruby
require 'simple_forex'
convert(amount, from_currency, to_currency)
```

For example 

```ruby
require 'simple_forex'
convert(100, 'USD', 'EUR')
# => 0.939717e2
```

Note the decimal value returned uses scientific notation, evidenced by the `e` in the decimal's representation.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/stevecondylios/simple_forex.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

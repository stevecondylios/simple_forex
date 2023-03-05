# EasyMoney

The goal of the easy_money gem is to help you quickly:

- Add a currencies table to your rails app
- Schedule the retrieval of up to date foreign exchange data (hourly from a free API)
- Convert between currencies

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add easy_money
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install easy_money
```

## Usage



### Add a currencies table to your rails app

After installing the gem, run this to add a currencies table to your rails app 

```bash
rails generate easy_money
```

followed by 

```
rake db:migrate
```

### Run a rake task to update currencies 


Get a [free API key](https://openexchangerates.org/signup/free), open credentials.yml (`EDITOR="vim" rails credentials:edit`) and add the API key to credentials.yml like so:

```
easy_money:
  openexchangerates_key: 1234AB
```

Then, run this to retrieve currencies in the currencies table:

```bash
rake easy_money:fetch_rates
```

Confirm it worked in the rails console with something like `Currency.last`.


### Schedule it 

**Optional**

Schedule the `easy_money:fetch_rates` rake task to run at the frequency you require. 

Tip: open exchange rates's free API gives 1000 calls monthly, and there are ~700 hours in month, so you safely run it hourly while staying within the free limit.


### Convert between currencies

Convert currencies by calling 


```ruby
require 'easy_money'
convert(amount, from_currency, to_currency)
```


### Example 

```ruby
require 'easy_money'
convert(100, 'USD', 'EUR')
# => 89.0
```



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/stevecondylios/easy_money.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

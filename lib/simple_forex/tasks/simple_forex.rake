

# Useful example from ryanb's letter_opener gem
# namespace :tmp do
#   task :zzzzzzzzzzzzzz do
#     rm_rf Dir["tmp/letter_opener/[^.]*"], verbose: false
#   end

#   task zzzzzzzzz: :letter_opener
# end





# Run from terminal with: RAILS_ENV=test rake fetch_rates

desc "This retrieves currency data"
namespace :simple_forex do
  task :fetch_rates => :environment do


    error_message = """
    Missing openexchangerates_key in credentials.
    Please ensure you have added the key to your credentials.

    Edit credentials.yml with 

    ```
    EDITOR=\"vim\" rails credentials:edit
    ```

    It should contain lines like this:

    ```
    simple_forex:
      openexchangerates_key: 1234AB
    ```
    """
    # from = "AUDz"
    # error_message % {currency_code: from}

     

    begin
      openexchangerates_key = Rails.application.credentials.simple_forex.openexchangerates_key
    rescue => exception
       $stderr.puts "Error: #{exception} - \n\n" + error_message + "\n\n"
    end




    
    open_exchange_rates_url = "https://openexchangerates.org/api/latest.json?app_id=" + openexchangerates_key

    cur = JSON.load(URI.open(open_exchange_rates_url))

    # Iterate over each of the rates and ensure it's a decimal, otherwise it could mess with multiplication later
    # Here's why decimal over float;
    # https://stackoverflow.com/a/8523253/5783745
    # TL;DR slightly more accurate, slightly less performant
    cur["rates"].each { |code, rate| cur["rates"][code] = rate.to_d }

    Currency.create!(blob: cur)

    success_message = """
    Successfully updated %{number_of_currencies} currencies.
    View them with `Currency.last.blob[\"rates\"].keys` or `Currency.last`.
    """

    puts success_message % {number_of_currencies: Currency.last.blob["rates"].count.to_s }

  end
end





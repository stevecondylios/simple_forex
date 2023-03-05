require 'easy_money'
require 'rails'

module EasyMoney
  class Railtie < Rails::Railtie
    railtie_name :easy_money

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end
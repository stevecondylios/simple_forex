require 'simple_forex'

module SimpleForex
  class Railtie < Rails::Railtie
    railtie_name :simple_forex

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end
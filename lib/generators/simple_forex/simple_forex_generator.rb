require "rails/generators"
require "rails/generators/active_record"

# This generator adds a migration for the {FriendlyId::History
# FriendlyId::History} addon.
class SimpleForexGenerator < ActiveRecord::Generators::Base
  # ActiveRecord::Generators::Base inherits from Rails::Generators::NamedBase which requires a NAME parameter for the
  # new table name. Our generator always uses 'friendly_id_slugs', so we just set a random name here.
  argument :name, type: :string, default: "a_temporary_name"

  class_option :'skip-migration', type: :boolean, desc: "Don't generate a migration for the currencies table"
  class_option :'skip-initializer', type: :boolean, desc: "Don't generate an initializer"

  source_root File.expand_path("../../../simple_forex", __FILE__)

  # Copies the migration template to db/migrate.
  def copy_files
    return if options["skip-migration"]
    migration_template "migration.rb", "db/migrate/create_currencies.rb"
  end


  # # Uncomment to copy /lib/simple_forex/initializer.rb to config/initializers/SimpleForex.rb
  # def create_initializer
  #   return if options["skip-initializer"]
  #   copy_file "initializer.rb", "config/initializers/SimpleForex.rb"
  # end
end

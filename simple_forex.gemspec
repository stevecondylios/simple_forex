# frozen_string_literal: true

require_relative "lib/simple_forex/version"

Gem::Specification.new do |spec|
  spec.name = "simple_forex"
  spec.version = SimpleForex::VERSION
  spec.authors = ["Steve Condylios"]
  spec.email = ["steve.condylios@gmail.com"]

  spec.summary = "simple_forex lets you quickly set up currency conversion capabilities in your Rails application."
  spec.description = "simple_forex lets you setup and use currency conversion in your Rails application. It includes a migration for a currencies table that stores all world currencies, including some cryptocurrencies. It also includes a rake task for retrieving up to date foreign exchange rates, and methods to conveniently convert between currencies."
  spec.homepage = "https://github.com/stevecondylios/simple_forex"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/stevecondylios/simple_forex"
  spec.metadata["changelog_uri"] = "https://github.com/stevecondylios/simple_forex/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "activerecord"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

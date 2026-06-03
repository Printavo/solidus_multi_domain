# encoding: UTF-8

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "solidus_multi_domain"
  s.version     = "2.0.0.alpha"
  s.summary     = "Adds multiple site support to Solidus"
  s.description = "Multiple Solidus stores on different domains - single unified backed for processing orders."
  s.required_ruby_version = ">= 2.1"

  s.author       = "Solidus Team"
  s.email        = "contact@solidus.io"
  s.homepage     = "https://solidus.io"
  s.license      = %q{BSD-3}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = "lib"
  s.requirements << "none"

  s.add_dependency "solidus", ['>= 1.1', '< 3']
  s.add_dependency "solidus_support"

  # rspec-rails 7.1 is the last line that keeps fixture_path= (removed in 8.x).
  s.add_development_dependency "rspec-rails",  "~> 7.1"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "sass-rails"
  # sprockets 4 is required for the asset manifest pipeline under Rails 7.2/8.0.
  s.add_development_dependency "sprockets", "~> 4"
  s.add_development_dependency "factory_bot", "~> 4.5"
  s.add_development_dependency "capybara"
  # poltergeist (PhantomJS) is dead; drive js: true specs with headless Chrome.
  s.add_development_dependency "selenium-webdriver"
  # puma is needed as the Capybara app server for the Selenium driver.
  s.add_development_dependency "puma"
  s.add_development_dependency "capybara-screenshot"
  s.add_development_dependency "database_cleaner", "~> 2.0"
  s.add_development_dependency "ffaker"
  # Stdlib gems extracted from Ruby 3.4 default gems; required transitively
  # (observer by factory_bot 4.x; mutex_m/benchmark by activesupport).
  s.add_development_dependency "observer"
  s.add_development_dependency "mutex_m"
  s.add_development_dependency "benchmark"
end

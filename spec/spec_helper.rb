require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'
require 'ffaker'

require 'database_cleaner'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'

# poltergeist (PhantomJS) is unmaintained; drive js: true specs with headless Chrome.
# (mirrors solidusio/solidus backend spec_helper)
require 'selenium-webdriver'
Capybara.register_driver(:selenium_chrome_headless) do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless=new')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_argument('--window-size=1920,1080')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
Capybara.javascript_driver = :selenium_chrome_headless
Capybara.default_max_wait_time = 10

# Permit the column types Solidus stores as serialized YAML; Psych 4 (Ruby 3.1+)
# raises Psych::DisallowedClass otherwise. (mirrors solidusio/solidus#4451)
ActiveRecord.yaml_column_permitted_classes |= [BigDecimal, Date, Symbol, Time]

# SolidusSupport::EngineExtensions only auto-loads app/decorators/; the extension's
# controller and API decorators (app/controllers/**/*_decorator.rb) sit dormant in the
# dummy app, so the prepends never apply. Force-load them (and the lib decorators).
# Upstream later restructured decorators under app/decorators/ to fix this.
# (mirrors the app/decorators/ consolidation in solidusio-contrib/solidus_multi_domain#172)
engine_root = File.expand_path('../..', __FILE__)
Dir[File.join(engine_root, 'app/controllers/**/*_decorator.rb')].sort.each { |f| require_dependency f }
Dir[File.join(engine_root, 'lib/spree/search/*.rb')].sort.each { |f| require_dependency f }

# Requires factories defined in spree_core. The bare `factories` entrypoint is
# deprecated; its deprecation points at the non-deprecated FactoryBot loader.
require 'spree/testing_support/factory_bot'
Spree::TestingSupport::FactoryBot.add_paths_and_load!
require 'spree_multi_domain/testing_support/factory_overrides'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/preferences'
require 'spree/api/testing_support/helpers'
require 'spree/api/testing_support/setup'
require 'spree/testing_support/capybara_ext'

require 'cancan/matchers'

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each { |f| require f }

# rake test_app's chained db setup can leave the test schema stale; the standard
# rails_helper recovery is to re-apply pending migrations into the test DB.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.mock_with :rspec

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.use_transactional_fixtures = false

  config.include FactoryBot::Syntax::Methods
  config.include Spree::TestingSupport::ControllerRequests, type: :controller
  config.include Spree::Api::TestingSupport::Helpers, type: :controller

  config.before :suite do
    DatabaseCleaner.clean_with :truncation
  end

  config.before do
    DatabaseCleaner.strategy = RSpec.current_example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end

  # Headless Chrome reports screen.width=800 regardless of --window-size, which hides
  # the admin nav; force real viewport metrics over the CDP for js: true specs.
  # (mirrors the CDP Emulation.setDeviceMetricsOverride hook in Printavo/solidus#2)
  config.before(:each, js: true) do
    page.driver.browser.execute_cdp(
      'Emulation.setDeviceMetricsOverride',
      width: 1920, height: 1080, deviceScaleFactor: 1, mobile: false
    )
  end
end

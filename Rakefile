require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

task :default do
  if Dir["spec/dummy"].empty?
    Rake::Task[:test_app].invoke
    Dir.chdir("../../")
  end
  Rake::Task[:spec].invoke
end

desc "Generates a dummy app for testing"
task :test_app do
  ENV['LIB_NAME'] = 'solidus_multi_domain'
  ENV['RAILS_ENV'] = 'test'

  require 'solidus_multi_domain'

  unless defined?(Solidus::InstallGenerator)
    require 'generators/solidus/install/install_generator'
  end
  require 'generators/spree/dummy/dummy_generator'

  Spree::DummyGenerator.start ["--lib_name=solidus_multi_domain", "--quiet"]
  Solidus::InstallGenerator.start ["--lib_name=solidus_multi_domain", "--auto-accept", "--with-authentication=false", "--payment-method=none", "--migrate=false", "--seed=false", "--sample=false", "--quiet", "--user_class=Spree::LegacyUser"]

  # On Rails 8 the generated dummy app ships without app/assets/config/manifest.js,
  # so sprockets-rails 3.5 raises Sprockets::Railtie::ManifestNeededError on boot
  # (before migrations can be copied). Seed the manifest so the app boots.
  # (mirrors solidusio/solidus#3379, solidusio/solidus#6327)
  manifest_dir = File.join('spec', 'dummy', 'app', 'assets', 'config')
  manifest_file = File.join(manifest_dir, 'manifest.js')
  unless File.exist?(manifest_file)
    require 'fileutils'
    FileUtils.mkdir_p(manifest_dir)
    File.write(manifest_file, "//= link_tree ../images\n//= link_directory ../stylesheets .css\n")
  end

  puts "Setting up dummy database..."
  # rake test_app's chained db:create/db:migrate can leave the sqlite file empty;
  # split into discrete bin/rails invocations. The engine auto-appends its own
  # db/migrate to the app migrator, so a single db:migrate applies the extension's
  # migrations directly. (We intentionally skip the install generator's copy step:
  # copying with fresh timestamps while the engine path stays active leaves the
  # original-timestamp migrations forever "pending" against maintain_test_schema!.)
  sh "bin/rails db:environment:set RAILS_ENV=test"
  sh "bin/rails db:drop db:create RAILS_ENV=test"
  sh "bin/rails db:migrate VERBOSE=false RAILS_ENV=test"
end

source "https://rubygems.org"

# Consume the Printavo Solidus fork: Solidus 2.11.16 + Rails 8 compat + state_machines pin.
# This branch boots on BOTH the Rails 7.2 and 8.0 axes.
gem "solidus", git: "https://github.com/Printavo/solidus.git", branch: "rails-8.0-support"

# Rails version is selected per-axis via RAILS_VERSION so one tree verifies both 7.2 and 8.0.
gem "rails", ENV.fetch("RAILS_VERSION", "~> 8.0"), require: false

gem "rails-controller-testing", group: :test

group :development, :test do
  gem "pry-rails"
end

gemspec

require 'bundler/setup'
require 'minitest/autorun'
require 'pry'

ENV["RAILS_ENV"] = "test"
ENV['DATABASE_URL'] = 'sqlite3://localhost/:memory:'

# Fix for Ruby 3.1+ logger compatibility with Rails 6.0+
require 'logger' if RUBY_VERSION >= "3.0"

require 'rails'

case Rails.version.slice(0, 3)
when "4.2"
  require "apps/rails42"
when "5.2"
  require "apps/rails52"
when "6.0"
  require "apps/rails60"
when "6.1"
  require "apps/rails61"
when "7.0"
  require "apps/rails70"
when "7.1"
  require "apps/rails71"
when "7.2"
  require "apps/rails72"
when "8.0"
  require "apps/rails80"
else
  raise "Version #{Rails.version} of Rails is not configured for testing."
end

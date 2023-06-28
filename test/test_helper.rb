require 'bundler/setup'
require 'minitest/autorun'
require 'example'

ENV["RAILS_ENV"] = "test"
ENV['DATABASE_URL'] = 'sqlite3://localhost/:memory:'

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
end

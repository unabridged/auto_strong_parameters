require "bundler/gem_tasks"
require "rake/testtask"
require 'appraisal'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
end

desc "Run tests"
task default: :test
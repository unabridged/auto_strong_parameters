require "bundler/gem_tasks"
require "rake/testtask"
require 'appraisal'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
end

desc "Run tests"
task default: :test

task :appr_31 do
  cmd = <<~CMD
    # Run appraisals under Ruby 3.1
    rbenv local 3.1.7
    echo "Testing Ruby 3.1 Rails versions..." &&
    bundle exec appraisal rails-4-2 rake test > /dev/null 2>&1 && echo "✅ Rails 4.2: PASSED" || echo "❌ Rails 4.2: FAILED" &&
    bundle exec appraisal rails-5-2 rake test > /dev/null 2>&1 && echo "✅ Rails 5.2: PASSED" || echo "❌ Rails 5.2: FAILED"
  CMD
  system cmd
end

task :appr_33 do
  cmd = <<~CMD
    # Run Ruby 3.3 appraisals
    rbenv local 3.3.7
    echo "Testing Ruby 3.3 Rails versions..." &&
    bundle exec appraisal rails-6-0 rake test > /dev/null 2>&1 && echo "✅ Rails 6.0: PASSED" || echo "❌ Rails 6.0: FAILED" &&
    bundle exec appraisal rails-6-1 rake test > /dev/null 2>&1 && echo "✅ Rails 6.1: PASSED" || echo "❌ Rails 6.1: FAILED" &&
    bundle exec appraisal rails-7-0 rake test > /dev/null 2>&1 && echo "✅ Rails 7.0: PASSED" || echo "❌ Rails 7.0: FAILED" &&
    bundle exec appraisal rails-7-1 rake test > /dev/null 2>&1 && echo "✅ Rails 7.1: PASSED" || echo "❌ Rails 7.1: FAILED" &&
    bundle exec appraisal rails-7-2 rake test > /dev/null 2>&1 && echo "✅ Rails 7.2: PASSED" || echo "❌ Rails 7.2: FAILED" &&
    bundle exec appraisal rails-8-0 rake test > /dev/null 2>&1 && echo "✅ Rails 8.0: PASSED" || echo "❌ Rails 8.0: FAILED"
  CMD
  system cmd
end

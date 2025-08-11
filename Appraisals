appraise "rails-4-2" do
  gem "rails", "~> 4.2.11", source: "https://gems.railslts.com"
  gem "ruby3-backward-compatibility" if RUBY_VERSION >= "3.0"
end

appraise "rails-5-2" do
  gem "rails", "~> 5.2.8"
  gem "ruby3-backward-compatibility" if RUBY_VERSION >= "3.0"
end

appraise "rails-6-0" do
  gem "rails", "~> 6.0.6"
  gem "logger" # Fix Ruby 3.1+ compatibility
end

appraise "rails-6-1" do
  gem "rails", "~> 6.1.7"
  gem "logger" # Fix Ruby 3.1+ compatibility
end

appraise "rails-7-0" do
  gem "rails", "~> 7.0"
  gem "logger" # Fix Ruby 3.1+ compatibility
end

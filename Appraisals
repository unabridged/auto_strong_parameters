if RUBY_VERSION.match?(/\A3.1/)
  appraise "rails-4-2" do
    gem "rails", "~> 4.2.11", source: "https://gems.railslts.com"
    gem "ruby3-backward-compatibility" if RUBY_VERSION >= "3.0"
  end

  appraise "rails-5-2" do
    gem "rails", "~> 5.2.8", source: "https://gems.railslts.com"
    gem "ruby3-backward-compatibility" if RUBY_VERSION >= "3.0"
    # Pin Rack to version compatible with Rails 5.2 and Ruby 3.1+
    gem "rack", "~> 2.0.9"
  end
elsif RUBY_VERSION.match?(/\A3.3/)
  appraise "rails-6-0" do
    gem "rails", "~> 6.0.6"
  end

  appraise "rails-6-1" do
    gem "rails", "~> 6.1.7"
  end

  appraise "rails-7-0" do
    gem "rails", "~> 7.0.8"
  end

  appraise "rails-7-1" do
    gem "rails", "~> 7.1.5"
  end

  appraise "rails-7-2" do
    gem "rails", "~> 7.2.2"
    gem 'stringio'
    gem 'erb'
  end

  appraise "rails-8-0" do
    gem "rails", "~> 8.0.2"
  end
end

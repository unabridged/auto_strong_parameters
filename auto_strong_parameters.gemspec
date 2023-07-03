$:.push File.expand_path("../lib", __FILE__)

require 'auto_strong_parameters/version'

Gem::Specification.new do |s|
  s.name        = "auto_strong_parameters"
  s.version     = AutoStrongParameters::VERSION
  s.summary     = "Automatic require and permit of Strong Paramters for your Rails forms."
  s.authors     = ["Drew Ulmer"]
  s.email       = "drew@unabridgedsoftware.com"
  s.homepage    = "https://github.com/unabridged/auto_strong_parameters"
  s.license     = "MIT"

  s.files = Dir["lib/**/*"] + ["Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.0"

  s.add_development_dependency "rake"
  s.add_development_dependency "minitest"
  s.add_development_dependency "appraisal"
  s.add_development_dependency "pry"
end

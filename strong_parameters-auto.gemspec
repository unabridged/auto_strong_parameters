$:.push File.expand_path("../lib", __FILE__)

require 'strong_parameters/auto/version'

Gem::Specification.new do |s|
  s.name        = "strong_parameters-auto"
  s.version     = StrongParameters::Auto::VERSION
  s.summary     = "Automatic require and permit of Strong Paramters for your Rails forms."
  s.authors     = ["Drew Ulmer"]
  s.email       = "drew@unabridgedsoftware.com"
  s.homepage    = "https://github.com/unabridged/strong_parameters-auto"
  s.license     = "MIT"

  s.files = Dir["lib/**/*"] + ["Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '>= 4.0'

  s.add_development_dependency "rake"
end

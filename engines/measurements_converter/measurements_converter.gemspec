$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "measurements_converter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "measurements_converter"
  s.version     = MeasurementsConverter::VERSION
  s.authors     = ["bilel"]
  s.email       = ["bilel.kedidi@gmail.com"]
  s.summary     = "Summary of MeasurementsConverter."
  s.description = " Description of MeasurementsConverter."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.0", ">= 5.0.0.1"

  s.add_development_dependency "sqlite3"
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aass/version'

Gem::Specification.new do |spec|
  spec.name          = "aass"
  spec.version       = AASS::VERSION
  spec.authors       = ["Tan Kian Keong"]
  spec.email         = ["kentan0130@gmail.com"]
  spec.summary       = %q{State Setter}
  spec.description   = %q{State Setter}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end

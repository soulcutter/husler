# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'husler/version'

Gem::Specification.new do |gem|
  gem.name          = "husler"
  gem.version       = Husler::VERSION
  gem.authors       = ["Bradley Schaefer"]
  gem.email         = ["bradley.schaefer@gmail.com"]
  gem.description   = %q{A ruby implementation of HUSL, a human-friendly color space}
  gem.summary       = %q{A ruby implementation of HUSL, a human-friendly color space}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec', '>= 2.11.0'
end

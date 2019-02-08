# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/virtus/version'

Gem::Specification.new do |gem|
  gem.name          = 'rspec_virtus'
  gem.version       = RSpec::Virtus::VERSION
  gem.authors       = ['Michael Smith', 'Alexander Simonov', 'Mohamed Diaa']
  gem.email         = ['mike@spokefire.co.uk', 'alex@simonov.me', 'mohamed.diaa27@gmail.com']
  gem.description   = 'Simple RSpec matchers for Virtus objects'
  gem.summary       = 'Simple RSpec matchers for Virtus objects'
  gem.homepage      = 'https://github.com/simonoff/rspec_virtus'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'rspec', '>= 3.0'
  gem.add_dependency 'virtus', '>= 1.0'

  gem.add_development_dependency 'rake', '~> 10.0.0'
end

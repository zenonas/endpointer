# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'endpointer/version'

Gem::Specification.new do |spec|
  spec.name          = "endpointer"
  spec.version       = Endpointer::VERSION
  spec.authors       = ["Zen Kyprianou"]
  spec.email         = ["endpointer@zenonas.com"]

  spec.summary       = %q{For when you stacks too big for your box}
  spec.description   = %q{Allows you to define endpoints to serve via a small caching proxy}
  spec.homepage      = "https://github.com/zenonas/endpointer"
  spec.license       = "MIT"
  spec.required_ruby_version = '>= 2.2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = ["endpointer"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "webmock"

  spec.add_dependency "rest-client"
  spec.add_dependency "sinatra"
end

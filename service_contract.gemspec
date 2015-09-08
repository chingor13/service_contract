# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'service_contract/version'

Gem::Specification.new do |spec|
  spec.name          = "service_contract"
  spec.version       = ServiceContract::VERSION
  spec.authors       = ["Jeff Ching"]
  spec.email         = ["jching@avvo.com"]
  spec.summary       = %q{Abstract the definition of a service's interface contract}
  spec.description   = %q{Abstract the definition of a service's interface contract. Supports Avro}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "avro", "~> 1.7"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5"
  spec.add_development_dependency "faker"
end

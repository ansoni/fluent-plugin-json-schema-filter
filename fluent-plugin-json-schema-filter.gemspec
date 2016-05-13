# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-json-schema-filter"
  spec.version       = "0.0.2"
  spec.authors       = ["Anthony Johnson"]
  spec.email         = ["ansoni@gmail.com"]

  spec.summary       = %q{Fluentd Filter plugin to validate incoming records against a json schema}
  spec.description   = %q{Fluentd Filter plugin to validate incoming records against a json schema.  It is thought that this would be helpful for maintaing a consistent record database.}
  spec.homepage      = "https://github.com/ansoni/fluent-plugin-json-schema-filter"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "travis", "~> 1.8"
  spec.add_development_dependency "test-unit", ">= 3.1.0"
  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_runtime_dependency "fluentd"
  spec.add_runtime_dependency "json-schema", "~> 2.6"
end

# coding: utf-8

begin
  require "./lib/params_collector/version"
rescue LoadError
  module ParamsCollector; VERSION = "0"; end
end

Gem::Specification.new do |spec|
  spec.name          = "params_collector"
  spec.version       = ParamsCollector::VERSION
  spec.authors       = ["Szymon Kopciewski"]
  spec.email         = "s.kopciewski@gmail.com"
  spec.summary       = ""
  spec.description   = ""
  spec.homepage      = "https://github.com/skopciewski/params_collector"
  spec.license       = "GPL-3.0"

  spec.require_paths = ["lib"]
  spec.files         = Dir.glob("{bin,lib}/**/*") + \
    %w(Gemfile LICENSE README.md CHANGELOG.md)

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-given"
  spec.add_development_dependency "pry"
end

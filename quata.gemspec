lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'quata/version'

Gem::Specification.new do |s|
  s.name        = 'quata'
  s.version     = Quata::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Quandl API Library and Command Line"
  s.description = "Easy to use API for Quandl data service with a command line interface"
  s.authors     = ["Danny Ben Shitrit"]
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.executables = ["quata"]
  s.homepage    = 'https://github.com/DannyBen/quata'
  s.license     = 'MIT'
  s.required_ruby_version = ">= 2.3.0"

  s.add_runtime_dependency 'super_docopt', '~> 0.1'
  s.add_runtime_dependency 'awesome_print', '~> 1.8'
  s.add_runtime_dependency 'apicake', '~> 0.1'
end

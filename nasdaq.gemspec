lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nasdaq/version'

Gem::Specification.new do |s|
  s.name        = 'nasdaq'
  s.version     = Nasdaq::VERSION
  s.summary     = 'Nasdaq Data Link API Library and Command Line'
  s.description = 'Easy to use API for the Nasdaq Data Link API with a command line interface'
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.executables = ['nasdaq']
  s.homepage    = 'https://github.com/DannyBen/nasdaq'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 2.7'

  s.add_runtime_dependency 'apicake', '~> 0.1'
  s.add_runtime_dependency 'lp', '~> 0.2'
  s.add_runtime_dependency 'super_docopt', '~> 0.2'


  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/DannyBen/nasdaq/issues',
    'changelog_uri'         => 'https://github.com/DannyBen/nasdaq/blob/master/CHANGELOG.md',
    'source_code_uri'       => 'https://github.com/DannyBen/nasdaq',
    'rubygems_mfa_required' => 'true',
  }
end

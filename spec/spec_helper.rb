require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

include Nasdaq

RSpec.configure do |config|
  config.example_status_persistence_file_path = 'spec/status.txt'
  config.filter_run_excluding :premium unless ENV['NASDAQ_PREMIUM']
  config.before :suite do
    puts 'Running spec_helper > before :suite'
    puts 'Flushing cache'
    APICake::Base.new.cache.flush
  end
end

def fixture(filename, data = nil)
  if data
    File.write "spec/fixtures/#{filename}", data
    raise <<~WARN
      Warning: Fixture data was written.
      This is perfectly fine if it was intended,
      but tests cannot proceed with it as a precaution.
    WARN
  else
    File.read "spec/fixtures/#{filename}"
  end
end

require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

include Quata

RSpec.configure do |config|
  config.filter_run_excluding type: :premium unless ENV['QUANDL_PREMIUM']
  config.before :suite do 
    puts "Running spec_helper > before :suite"
    puts "Flushing cache"
    APICake::Base.new.cache.flush
  end
end

def fixture(filename, data=nil)
  if data
    File.write "spec/fixtures/#{filename}", data
    raise "Warning: Fixture data was written.\nThis is perfectly fine if it was intended,\nbut tests cannot proceed with it as a precaution."
  else
    File.read "spec/fixtures/#{filename}"
  end
end
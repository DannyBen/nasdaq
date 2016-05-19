require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

require 'webmock/rspec'

include Quata

require_relative 'support'
include TestSupport

RSpec.configure do |config|
  config.filter_run_excluding type: :premium unless ENV['QUANDL_PREMIUM']
end

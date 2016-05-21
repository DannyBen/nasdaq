require 'json'

# Provides access to all the Quandl API endpoints
class Quandl < Quata::WebAPI
  attr_reader :api_key

  def initialize(api_key=nil, opts={})
    if api_key.is_a? Hash
      opts = api_key
      api_key = nil
    end

    @api_key = api_key

    defaults = {
      use_cache: false,
      cache_dir: nil,
      cache_life: nil,
      base_url: 'https://www.quandl.com/api/v3'
    }

    opts = defaults.merge! opts

    self.cache.disable unless opts[:use_cache]
    self.cache.dir = opts[:cache_dir] if opts[:cache_dir]
    self.cache.life = opts[:cache_life] if opts[:cache_life]

    param auth_token: api_key if api_key
    self.format = :json

    after_request do |response| 
      begin
        JSON.parse response, symbolize_names: true
      rescue JSON::ParserError
        response
      end
    end
    
    super opts[:base_url]
  end
end

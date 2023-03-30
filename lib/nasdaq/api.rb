require 'apicake'

module Nasdaq
  # Provides access to all the Quandl API endpoints
  class API < APICake::Base
    base_uri 'https://data.nasdaq.com/api/v3'

    attr_reader :api_key

    # TODO: handle format

    # Initializes the API with an optional API Key, and cache settings.
    def initialize(api_key = nil, opts = {})
      if api_key.is_a?(Hash) && opts.empty?
        opts = api_key
        api_key = nil
      end
      @api_key = api_key
      cache.disable unless opts[:use_cache]
      cache.dir = opts[:cache_dir] if opts[:cache_dir]
      cache.life = opts[:cache_life] if opts[:cache_life]
    end

    # Returns a hash that will be merged into all query strings before
    # sending the request to Quandl. This method is used by API Cake.
    def default_query
      { api_key: api_key }
    end

    # Forwards all arguments to #get! and converts the JSON response to CSV
    # If the response contains one or more arrays, the first array will be
    # the CSV output. Otherwise, the response itself will be used.
    def get_csv(path, params = {})
      path = "#{path}.csv"
      payload = get! path, params

      if payload.response.code != '200'
        raise Nasdaq::BadResponse, "#{payload.response.code} #{payload.response.msg}"
      end

      payload.response.body
    end
  end
end

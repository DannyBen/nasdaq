require 'uri'
require 'open-uri'

module Quata

  class WebAPI
    attr_reader :base_url, :after_request_block, :debug_mode

    def initialize(base_url)
      @base_url = base_url
    end

    # Allow using any method as the first segment of the path
    # object.user 'details' becomes object.get 'user/details'
    def method_missing(method_sym, *arguments, &block)
      begin
        get "/#{method_sym}", *arguments
      rescue
        super
      end
    end

    # Add a parameter to the default query string. Good for adding keys that
    # are always needed, like API keys.
    def param(key, value)
      default_params[key] = value
    end

    # Set the default format that will be appended to the URL. value can be 
    # a string or a symbol.
    def format(value=nil)
      @format = value if value
      @format
    end

    # Set debug mode, which will return the requested, restructured URL 
    # instead of returning the response.
    def debug(value)
      @debug_mode = value
    end

    # Set a block to be executed after the request. This is called only when
    # using `get` and not when using `get!`. Good for JSON decoding, for 
    # example.
    def after_request(&block)
      @after_request_block = block
    end

    # Return the response from teh API. 
    def get(path, extra=nil, params={})
      response = get! path, extra, params
      response = after_request_block.call(response) if after_request_block
      response
    end

    # Return the response from the API, without executing the after_request
    # block.
    def get!(path, extra=nil, params={})
      if extra.is_a?(Hash) and params.empty?
        params = extra
        extra = nil
      end
      
      path = "#{path}/#{extra}" if extra
      url = construct_url path, params

      debug_mode ? url : http_get(url)
    end

    # Save the response from the API to a file.
    def save(filename, path, params={})
      response = get! path, nil, params
      return response if debug_mode
      File.write filename, response.to_s
    end

    # Build a URL from all its explicit and implicit pieces.
    def construct_url(path, params={})
      path = "/#{path}" unless path[0] == '/'
      all_params = default_params.merge params
      result = "#{base_url}#{path}"
      result = "#{result}.#{format}" if format && File.extname(result) == ''
      unless all_params.empty?
        all_params = URI.encode_www_form all_params
        result = "#{result}?#{all_params}"
      end
      result
    end

    def default_params
      @default_params ||= {}
    end

    private

    def http_get(url)
      open(url).read
    end
  end

end

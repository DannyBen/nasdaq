require 'singleton'
require 'super_docopt'
require 'json'
require 'awesome_print'

module Quata

  # Handles the command line interface
  class CommandLine < SuperDocopt::Base
    version VERSION
    docopt File.expand_path 'docopt.txt', __dir__
    subcommands ['get', 'pretty', 'see', 'url', 'save']

    attr_reader :path, :params, :file, :csv

    def before_execute
      @path   = args['PATH']
      @params = translate_params args['PARAMS']
      @file   = args['FILE']
      @csv    = args['--csv']
    end

    def get
      if csv
        puts quandl.get_csv path, params
      else
        payload = quandl.get! path, params
        puts payload.response.body
      end
    end

    def save
      if csv
        success = quandl.save_csv file, path, params
      else
        success = quandl.save file, path, params
      end
      puts success ? "Saved #{file}" : "Saving failed"
    end

    def pretty
      payload = quandl.get path, params
      puts JSON.pretty_generate payload
    end

    def see
      ap quandl.get path, params
    end

    def url
      puts quandl.url path, params
    end

    def quandl
      @quandl ||= quandl!
    end

    private

    def quandl!
      API.new api_key, options
    end

    # Convert a params array like [key:value, key:value] to a hash like
    # {key: value, key: value}
    def translate_params(pairs)
      result = {}
      return result if pairs.empty?
      pairs.each do |pair|
        key, value = pair.split ':'
        result[key.to_sym] = value
      end
      result
    end

    def options
      result = {}
      return result unless cache_dir || cache_life

      result[:use_cache] = true
      result[:cache_dir] = cache_dir if cache_dir
      result[:cache_life] = cache_life.to_i if cache_life
      result
    end

    def api_key
      ENV['QUANDL_KEY']
    end

    def cache_dir
      ENV['QUANDL_CACHE_DIR']
    end

    def cache_life
      ENV['QUANDL_CACHE_LIFE']
    end

  end
end

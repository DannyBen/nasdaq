require 'singleton'
require 'docopt'
require 'json'
require 'awesome_print'

module Quata

  class CommandLine
    include Singleton

    attr_reader :quandl

    def initialize
      @quandl = Quandl.new api_key
      @quandl.format :csv
    end

    def execute(argv=[])
      doc = File.read File.dirname(__FILE__) + '/docopt.txt'
      begin
        args = Docopt::docopt(doc, argv: argv, version: VERSION)
        handle args
      rescue Docopt::Exit => e
        puts e.message
      end
    end

    private

    def handle(args)
      path   = args['PATH']
      params = args['PARAMS']
      file   = args['FILE']
      
      return get(path, params)        if args['get']
      return pretty(path, params)     if args['pretty']
      return see(path, params)        if args['see']
      return url(path, params)        if args['url']
      return save(file, path, params) if args['save']
    end

    def get(path, params)
      puts quandl.get! path, translate_params(params)
    end

    def save(file, path, params)
      success = quandl.save file, path, translate_params(params)
      puts success ? "Saved #{file}" : "Saving failed"
    end

    def pretty(path, params)
      quandl.format :json
      response = quandl.get path, translate_params(params)
      puts JSON.pretty_generate response
    end

    def see(path, params)
      quandl.format :json
      ap quandl.get path, translate_params(params)
    end

    def url(path, params)
      quandl.debug true
      puts quandl.get path, translate_params(params)
      quandl.debug false
    end

    def translate_params(params)
      return nil if params.empty?
      result = {}
      params.each do |param|
        key, value = param.split ':'
        result[key] = value
      end
      result
    end

    def api_key
      @api_key ||= ENV['QUANDL_KEY']
    end

  end

end

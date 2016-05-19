# Quandl
require 'json'

class Quandl < Quata::WebAPI
  attr_reader :api_key

  def initialize(api_key=nil, base_url=nil)
    @api_key = api_key

    base_url ||= 'https://www.quandl.com/api/v3'

    param :auth_token, api_key if api_key
    format :json

    after_request do |response| 
      begin
        JSON.parse response, symbolize_names: true
      rescue JSON::ParserError => e  
        response
      end
    end
    
    super base_url
  end
end

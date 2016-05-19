require 'spec_helper'

describe Quandl do
  describe '#new' do
    it "sets default format to json" do
      quandl = Quandl.new
      expect(quandl.format).to eq :json
    end

    it "initializes with api key" do
      quandl = Quandl.new '70p-53cr37'
      expect(quandl.api_key).to eq '70p-53cr37'
    end

    it "sets the api key as auth_token param" do
      quandl = Quandl.new '70p-53cr37'
      expect(quandl.default_params[:auth_token]).to eq '70p-53cr37'
    end

    it "initializes with a different base url" do
      quandl = Quandl.new 'key', 'http://new.quandl.com/v99'
      expect(quandl.base_url).to eq 'http://new.quandl.com/v99'
    end
  end

end

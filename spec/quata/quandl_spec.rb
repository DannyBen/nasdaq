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

    it "starts with cache disabled" do
      quandl = Quandl.new
      expect(quandl.cache).not_to be_enabled
    end

    it "initializes with options" do
      quandl = Quandl.new 'key', 
        base_url: 'http://new.quandl.com/v99',
        use_cache: true,
        cache_dir: 'custom',
        cache_life: 1337

      expect(quandl.base_url).to eq 'http://new.quandl.com/v99'
      expect(quandl.cache.dir).to eq 'custom'
      expect(quandl.cache.life).to eq 1337
      expect(quandl.cache).to be_enabled
    end

    context "without a key" do
      it "initializes with options" do
        quandl = Quandl.new use_cache: true
        expect(quandl.cache).to be_enabled
      end
    end
  end

end

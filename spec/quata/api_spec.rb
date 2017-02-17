require 'spec_helper'

describe API do
  describe '#new' do
    it "initializes with api key" do
      quandl = API.new '70p-53cr37'
      expect(quandl.api_key).to eq '70p-53cr37'
    end

    it "starts with cache disabled" do
      quandl = API.new
      expect(quandl.cache).not_to be_enabled
    end

    it "initializes with options" do
      quandl = API.new 'key', 
        use_cache: true, 
        cache_dir: 'custom',
        cache_life: 1337

      expect(quandl.cache.dir).to eq 'custom'
      expect(quandl.cache.life).to eq 1337
      expect(quandl.cache).to be_enabled
    end

    context "without a key" do
      it "initializes with options" do
        quandl = API.new use_cache: true
        expect(quandl.cache).to be_enabled
      end
    end
  end

end

require 'spec_helper'

describe API do
  before :all do
    ENV['QUANDL_KEY'] or raise "Please set QUANDL_KEY=y0urAP1k3y before running tests"
  end

  let(:quandl) { described_class.new ENV['QUANDL_KEY'], use_cache: true }

  describe '#new' do
    it "initializes with api key" do
      quandl = described_class.new 'my-api-key'
      expect(quandl.api_key).to eq 'my-api-key'
    end

    it "starts with cache disabled" do
      quandl = described_class.new 'my-api-key'
      expect(quandl.cache).not_to be_enabled
    end

    it "initializes with options" do
      quandl = described_class.new 'my-api-key',
        use_cache: true,
        cache_dir: 'custom',
        cache_life: 1337

      expect(quandl.cache.dir).to eq 'custom'
      expect(quandl.cache.life).to eq 1337
      expect(quandl.cache).to be_enabled
    end
  end

  describe '#get_csv' do
    context "with a time series response" do
      it "returns a csv string" do
        result = quandl.get_csv 'datasets/WIKI/FB', start_date: '2017-01-01', end_date: '2017-01-10'
        fixture = fixture 'fb.csv'
        expect(result).to match /#{fixture}/m
      end
    end

    context "with a non time series response" do
      it "returns a csv string" do
        result = quandl.get_csv 'datasets/WIKI/FB/metadata'
        fixture = fixture('fb-meta.csv')
        expect(result).to match /#{fixture}/m
      end
    end

    context "with a non hash response" do
      it "raises an error" do
        expect{quandl.get_csv :bogus_endpoint}.to raise_error(BadResponse)
      end
    end
  end

  describe '#save_csv' do
    let(:filename) { 'tmp.csv' }

    it "saves output to a file" do
      File.delete filename if File.exist? filename
      expect(File).not_to exist(filename)

      quandl.save_csv filename, 'datasets/WIKI/FB', start_date: '2017-01-01', end_date: '2017-01-10'
      
      expect(File).to exist(filename)
      fixture = fixture 'fb.csv'
      expect(File.read filename).to match /#{fixture}/m
      
      File.delete filename
    end
  end
end

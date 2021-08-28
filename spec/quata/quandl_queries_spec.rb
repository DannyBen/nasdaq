require 'spec_helper'

describe "quandl queries" do

  let(:quandl) { API.new ENV['QUANDL_KEY'] }
  let(:premium) { ENV['QUANDL_PREMIUM']}

  describe '#datasets' do
    before do
      @response = quandl.datasets 'WIKI/AAPL', rows: 3
    end

    it "returns a hash" do
      expect(@response).to have_key 'dataset'
      expect(@response['dataset']['dataset_code']).to eq 'AAPL'
    end

    it "obeys query string parameters" do
      expect(@response['dataset']['data'].length).to eq 3
    end
  end

  describe '#databases' do
    it "returns a hash" do
      response = quandl.databases per_page: 2
      expect(response['databases'].length).to eq 2
    end
  end

  describe '#get' do
    it "returns hash" do
      response = quandl.get "datasets/WIKI/AAPL", rows: 3
      expect(response).to have_key 'dataset'
    end

    it "returns a csv array" do
      response = quandl.get "datasets/WIKI/AAPL.csv", rows: 3
      expected = ["Date", "Open", "High", "Low"]
      expect(response).to be_an Array
      expect(expected - response.first).to be_empty
    end

    it "fails with honor" do
      response = quandl.get "no_can_do"
      expect(response).to match /Error.*We could not recognize the URL you requested: \/api\/v3\/no_can_do/
    end
  end

  describe '#save' do
    before do 
      system "rm tmp.zip" if File.exist? 'tmp.zip'
      expect(File).not_to exist 'tmp.zip'
    end

    after do
      system "rm tmp.zip" if File.exist? 'tmp.zip'
    end

    it "saves a file", type: :premium do
      quandl.save 'tmp.zip', "databases/#{premium}/data", download_type: 'partial'
      expect(File).to exist 'tmp.zip'
      expect(File.size 'tmp.zip').to be > 10000
    end
  end

end
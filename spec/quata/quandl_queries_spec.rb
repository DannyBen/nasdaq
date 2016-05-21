require 'spec_helper'

describe "quandl queries" do

  let(:quandl) { Quandl.new ENV['QUANDL_KEY'] }
  let(:premium) { ENV['QUANDL_PREMIUM']}

  describe '#datasets' do
    before do
      @response = quandl.datasets 'WIKI/AAPL', rows: 3
    end

    it "returns a hash" do      
      expect(@response).to have_key :dataset
      expect(@response[:dataset][:dataset_code]).to eq 'AAPL'
    end

    it "obeys query string parameters" do      
      expect(@response[:dataset][:data].length).to eq 3
    end
  end

  describe '#databases' do
    it "returns a hash" do
      response = quandl.databases per_page: 2
      expect(response[:databases].length).to eq 2
    end
  end

  describe '#get' do
    it "returns hash" do
      response = quandl.get "datasets/WIKI/AAPL", rows: 3
      expect(response).to have_key :dataset
    end

    it "returns csv" do
      response = quandl.get "datasets/WIKI/AAPL.csv", rows: 3
      expect(response).to match /Date,Open,High,Low,Close,Volume/
    end

    it "fails gracefully" do
      response = quandl.get "no_can_do"
      expect(response).to eq '400 Bad Request'
    end
  end

  describe '#get!' do
    it "returns raw json response" do
      response = quandl.get! "datasets/WIKI/AAPL", rows: 3
      expect {JSON.parse response}.to_not raise_error
      expect(JSON.parse response).to have_key 'dataset'
    end
  end

  describe '#save' do
    it "saves a file", type: :premium do
      File.unlink 'tmp.zip' if File.exist? 'tmp.zip'
      expect(File).not_to exist 'tmp.zip'

      quandl.save 'tmp.zip', "databases/#{premium}/data", download_type: 'partial'
      expect(File).to exist 'tmp.zip'
      expect(File.size 'tmp.zip').to be > 10000

      File.unlink 'tmp.zip'
    end
  end

end
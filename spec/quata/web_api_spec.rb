require 'spec_helper'

describe WebAPI do

  let(:base_url) { 'http://base.url.com' }
  let(:api) { WebAPI.new base_url }

  describe '#new' do
    it "sets base url" do
      expect(api.base_url).to eq 'http://base.url.com'
    end
  end

  describe '#param' do
    it "sets a default param" do
      api.param key: 'value'
      expect(api.default_params[:key]).to eq 'value'
    end

    it "appends params" do
      api.param duke: 'nukem', han: 'solo'
      api.param mike: 'wazowski'
      expect(api.default_params[:duke]).to eq 'nukem'
      expect(api.default_params[:mike]).to eq 'wazowski'
      expect(api.default_params[:han]).to eq 'solo'
    end

    it "deletes params" do
      api.param duke: 'nukem', han: 'solo'
      api.params han: nil
      expect(api.default_params).to_not have_key 'han'
      expect(api.default_params[:duke]).to eq 'nukem'
    end
  end

  describe '#format' do
    it "sets and gets format" do
      api.format :bson
      expect(api.format).to eq :bson
    end
  end

  describe '#after_request' do
    it "stores a block" do
      api.after_request { 'say hi' }
      expect(api.after_request_block).to be_a Proc
      expect(api.after_request_block.call).to eq 'say hi'
    end
  end

  describe '#construct url' do
    it "marges base_url with path" do
      expect(api.construct_url '/path').to eq "#{api.base_url}/path"
    end

    it "prepends path with / if needed" do
      expect(api.construct_url 'path').to eq "#{api.base_url}/path"
    end

    it "appends format" do
      api.format :json
      expect(api.construct_url 'path').to eq "#{api.base_url}/path.json"
    end

    it "does not append format if path contains one" do
      api.format :json
      expect(api.construct_url 'path.csv').to eq "#{api.base_url}/path.csv"
    end

    it "appends params as a query string" do
      api.param key: 'value'
      expect(api.construct_url 'path').to eq "#{api.base_url}/path?key=value"
    end

    it "merges default params with given params" do
      api.param key: 'value'
      expect(api.construct_url 'path', mac: 'cheese').to eq "#{api.base_url}/path?key=value&mac=cheese"
    end
  end

  describe '#get!' do
    context 'in debug mode' do
      before do
        api.debug true
      end

      it "creates a valid url" do
        response = api.get 'path', param: 'value'
        expect(response).to eq "#{base_url}/path?param=value"
      end

      it "merges extra path arguments" do
        response = api.get 'path', 'sub', param: 'value'
        expect(response).to eq "#{base_url}/path/sub?param=value"
      end
    end

  end

  describe '#get' do
    it "runs an after_request block" do
      stub_request(:any, "#{base_url}/path").to_return(body: 'body')
      api.after_request { |response| response.upcase }
      response = api.get 'path'
      expect(response).to eq 'BODY'
    end

    context "on failure" do
      it "returns a graceful http error" do
        stub_request(:any, "#{base_url}/path").to_return(body: 'Oops', status: [404, "Not Found"])
        response = api.get 'path'
        expect(response).to eq '404 Not Found'
      end
    end
  end

  describe '#method_missing' do
    it "converts to a #get call" do
      api.debug true
      expect(api.anything_you_want).to eq "#{base_url}/anything_you_want"
    end

    it "creates a valid url with all components" do
      api.debug true
      url = api.master 'extra', param1: 'value1', param2: 'value2'
      expect(url).to eq "#{base_url}/master/extra?param1=value1&param2=value2"
    end

    it "raises an exception on invalid url" do
      stub_request(:any, /#{base_url}/).to_raise NoMethodError
      expect {api.not_there}.to raise_error NoMethodError
    end
  end

  describe '#save' do
    it "saves a file" do
      File.unlink 'tmp.txt' if File.exist? 'tmp.txt'
      expect(File).not_to exist 'tmp.txt'
      stub_request(:any, "#{base_url}/path").to_return(body: 'body') 

      api.save 'tmp.txt', 'path'

      expect(File).to exist 'tmp.txt'
      expect(File.read 'tmp.txt').to eq 'body'
      File.unlink 'tmp.txt'
    end
  end

end
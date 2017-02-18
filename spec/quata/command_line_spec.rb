require 'spec_helper'

describe CommandLine do
  let(:cli) { Quata::CommandLine.instance }
  let(:premium) { ENV['QUANDL_PREMIUM']}

  before do
    ENV['QUANDL_CACHE_DIR'] = 'cache'
    ENV['QUANDL_CACHE_LIFE'] = '86400'
  end

  describe '#initialize' do
    let(:cli) { Quata::CommandLine.clone.instance }

    context "without environment variables" do
      before do
        ENV['QUANDL_CACHE_DIR'] = nil
        ENV['QUANDL_CACHE_LIFE'] = nil
      end

      it "has cache disabled" do
        expect(cli.quandl.cache).not_to be_enabled
      end
    end

    context "with CACHE_DIR" do
      it "enables cache" do
        ENV['QUANDL_CACHE_DIR'] = 'hello'
        expect(cli.quandl.cache).to be_enabled
        expect(cli.quandl.cache.dir).to eq 'hello'
        ENV.delete 'QUANDL_CACHE_DIR'
      end
    end

    context "with CACHE_LIFE" do
      it "enables cache" do
        ENV['QUANDL_CACHE_LIFE'] = '123'
        expect(cli.quandl.cache).to be_enabled
        expect(cli.quandl.cache.life).to eq 123
        ENV.delete 'QUANDL_CACHE_LIFE'
      end
    end
  end

  describe '#execute' do
    context "without arguments" do
      it "shows usage patterns" do
        expect {cli.execute}.to output(/Usage:/).to_stdout
      end
    end

    context "with url command" do
      let(:command) { %w[url doesnt really:matter] }

      it "returns a url" do
        expected = %r[quandl.com/api/v3/doesnt?.*really=matter]
        expect {cli.execute command}.to output(expected).to_stdout
      end
    end

    context "with get command" do
      let(:command) { %w[get datasets/WIKI/AAPL rows:5] }

      it "prints json output" do
        expected = /\{"dataset":.*\}/
        expect {cli.execute command}.to output(expected).to_stdout
      end
    end

    context "with get --csv command" do
      let(:command) { %w[get --csv datasets/WIKI/AAPL rows:5] }

      it "prints csv output" do
        expected = /Date,Open,High,Low,Close/
        expect {cli.execute command}.to output(expected).to_stdout
      end
    end

    context "with pretty command" do
      let(:command) { %w[pretty datasets/WIKI/AAPL rows:5] }

      it "prints a prettified json output" do
        expected = /"dataset_code": "AAPL",\n\s*"database_code": "WIKI"/
        expect {cli.execute command}.to output(expected).to_stdout
      end
    end

    context "with see command" do
      let(:command) { %w[see datasets/WIKI/AAPL rows:5] }

      it "awesome-prints output" do
        expected = /"dataset_code".*=>.*"AAPL"/
        expect {cli.execute command}.to output(expected).to_stdout
      end
    end

    context "with save command" do
      let(:command) { %W[save tmp.json datasets/WIKI/FB start_date:2017-01-01 end_date:2017-01-10] }
      let(:filename) { 'tmp.json' }

      before do 
        File.unlink filename if File.exist? filename
        expect(File).not_to exist filename
      end

      after do 
        File.unlink filename
      end

      it "saves a file" do
        expected = "Saved #{filename}\n"

        expect {cli.execute command}.to output(expected).to_stdout
        expect(File).to exist filename
        expect(File.read filename).to match /\{"dataset":\{"id":9775687,"dataset_code"/
      end
    end

    context "with save command and a bulk premium download" do
      let(:command) { %W[save tmp.zip databases/#{premium}/data download_type:partial] }
      let(:filename) { 'tmp.zip' }

      before do 
        File.unlink filename if File.exist? filename
        expect(File).not_to exist filename
      end

      after do
        File.unlink filename
      end

      it "saves a file", type: :premium do
        expected = "Saved tmp.zip\n"

        expect {cli.execute command}.to output(expected).to_stdout
        expect(File).to exist 'tmp.zip'
        expect(File.size 'tmp.zip').to be > 10000
      end
    end

    context "with save --csv command" do
      let(:command) { %W[save --csv tmp.csv datasets/WIKI/FB start_date:2017-01-01 end_date:2017-01-10] }
      let(:filename) { 'tmp.csv' }

      before do
        File.unlink filename if File.exist? filename
        expect(File).not_to exist filename
      end

      after do
        File.unlink filename
      end

      it "saves a csv file" do
        expected = "Saved #{filename}\n"

        expect {cli.execute command}.to output(expected).to_stdout
        expect(File).to exist filename
        fixture = fixture('fb.csv')
        expect(File.read filename).to match /#{fixture}/m
      end
    end

    context "with an invalid path" do
      let(:command) { %W[get not_here] }
      
      it "fails with honor" do
        expected = /Error.*We could not recognize the URL you requested: \/api\/v3\/not_here/
        expect {cli.execute command}.to output(expected).to_stdout
      end
    end
  end

end
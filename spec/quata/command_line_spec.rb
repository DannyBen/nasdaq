require 'spec_helper'

describe CommandLine do
  let(:cli) { Quata::CommandLine.instance }
  let(:premium) { ENV['QUANDL_PREMIUM']}

  describe '#initialize' do
    let(:cli) { Quata::CommandLine.clone.instance }

    context "without environment variables" do
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
      let(:command) { %W[save tmp.zip databases/#{premium}/data download_type:partial] }

      it "saves a file", type: :premium do
        File.unlink 'tmp.zip' if File.exist? 'tmp.zip'
        expect(File).not_to exist 'tmp.zip'
        expected = "Saved tmp.zip\n"

        expect {cli.execute command}.to output(expected).to_stdout
        expect(File).to exist 'tmp.zip'
        expect(File.size 'tmp.zip').to be > 10000

        File.unlink 'tmp.zip'
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
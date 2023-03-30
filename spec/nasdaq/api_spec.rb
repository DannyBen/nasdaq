describe API do
  before :all do
    ENV['NASDAQ_KEY'] or raise 'Please set NASDAQ_KEY=y0urAP1k3y before running tests'
  end

  let(:nasdaq) { described_class.new ENV['NASDAQ_KEY'], use_cache: true }

  describe '#new' do
    it 'initializes with api key' do
      nasdaq = described_class.new 'my-api-key'
      expect(nasdaq.api_key).to eq 'my-api-key'
    end

    it 'starts with cache disabled' do
      nasdaq = described_class.new 'my-api-key'
      expect(nasdaq.cache).not_to be_enabled
    end

    it 'initializes with options' do
      nasdaq = described_class.new 'my-api-key',
        use_cache:  true,
        cache_dir:  'custom',
        cache_life: 1337

      expect(nasdaq.cache.dir).to eq 'custom'
      expect(nasdaq.cache.life).to eq 1337
      expect(nasdaq.cache).to be_enabled
    end
  end

  describe '#get_csv' do
    context 'with a time series response' do
      it 'returns a csv string' do
        result = nasdaq.get_csv 'datasets/WIKI/FB', start_date: '2017-01-01', end_date: '2017-01-10'
        fixture = fixture 'fb.csv'
        expect(result).to match(/#{fixture}/m)
      end
    end

    context 'with a non time series response' do
      it 'returns a csv string' do
        result = nasdaq.get_csv 'datasets/WIKI/FB/metadata'
        fixture = fixture('fb-meta.csv')
        expect(result).to match(/#{fixture}/m)
      end
    end

    context 'with a non hash response' do
      it 'raises an error' do
        expect { nasdaq.get_csv :bogus_endpoint }.to raise_error(BadResponse)
      end
    end
  end

  describe '#save_csv' do
    let(:filename) { 'tmp.csv' }

    it 'saves output to a file' do
      File.delete filename if File.exist? filename
      expect(File).not_to exist(filename)

      nasdaq.save_csv filename, 'datasets/WIKI/FB', start_date: '2017-01-01', end_date: '2017-01-10'

      expect(File).to exist(filename)
      fixture = fixture 'fb.csv'
      expect(File.read filename).to match(/#{fixture}/m)

      File.delete filename
    end
  end
end

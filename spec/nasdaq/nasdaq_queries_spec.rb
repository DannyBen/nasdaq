describe 'nasdaq queries' do
  let(:nasdaq) { API.new ENV['NASDAQ_KEY'] }

  describe '#datasets' do
    let(:response) { nasdaq.datasets 'WIKI/AAPL', rows: 3 }

    it 'returns a hash' do
      expect(response).to have_key 'dataset'
      expect(response['dataset']['dataset_code']).to eq 'AAPL'
    end

    it 'obeys query string parameters' do
      expect(response['dataset']['data'].length).to eq 3
    end
  end

  describe '#get' do
    it 'returns hash' do
      response = nasdaq.get 'datasets/WIKI/AAPL', rows: 3
      expect(response).to have_key 'dataset'
    end

    it 'returns a csv array' do
      response = nasdaq.get 'datasets/WIKI/AAPL.csv', rows: 3
      expected = %w[Date Open High Low]
      expect(response).to be_an Array
      expect(expected - response.first).to be_empty
    end

    it 'fails with honor' do
      response = nasdaq.get 'no_can_do'
      expect(response).to match(/Error.*We could not recognize the URL you requested/)
    end
  end

  describe '#save' do
    before do
      system 'rm -f tmp.json'
      expect(File).not_to exist 'tmp.json'
    end

    after do
      system 'rm -f tmp.json'
    end

    it 'saves a file' do
      nasdaq.save 'tmp.json', 'datasets/WIKI/AAPL', rows: 5
      expect(File).to exist 'tmp.json'
      data = JSON.parse(File.read('tmp.json'))
      expect(data['dataset']['data'].count).to eq 5
    end
  end
end

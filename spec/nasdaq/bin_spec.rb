describe 'bin/nasdaq' do
  it 'shows usage patterns' do
    expect(`bin/nasdaq`).to match(/Usage:/)
  end

  it 'shows help' do
    expect(`bin/nasdaq --help`).to match(/Commands:/)
  end

  it 'shows version' do
    expect(`bin/nasdaq --version`).to eq "#{VERSION}\n"
  end

  context 'with bad response' do
    it 'exits with honor' do
      command = 'bin/nasdaq get --csv not_found 2>&1'
      expect(`#{command}`).to eq "Nasdaq::BadResponse - 400 Bad Request\n"
    end
  end
end

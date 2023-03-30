require 'spec_helper'

describe 'bin/quata' do
  it 'shows usage patterns' do
    expect(`bin/quata`).to match(/Usage:/)
  end

  it 'shows help' do
    expect(`bin/quata --help`).to match(/Commands:/)
  end

  it 'shows version' do
    expect(`bin/quata --version`).to eq "#{VERSION}\n"
  end

  context 'with bad response' do
    it 'exits with honor' do
      command = 'bin/quata get --csv not_found 2>&1'
      expect(`#{command}`).to eq "Quata::BadResponse - 400 Bad Request\n"
    end
  end
end

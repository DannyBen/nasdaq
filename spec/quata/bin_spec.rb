require 'spec_helper'

describe 'bin/quata' do
  it "shows usage patterns" do
    expect(`bin/quata`).to match /Usage:/
  end

  it "shows help" do
    expect(`bin/quata --help`).to match /Commands:/
  end

  it "shows version" do
    expect(`bin/quata --version`).to eq "#{VERSION}\n"
  end
end

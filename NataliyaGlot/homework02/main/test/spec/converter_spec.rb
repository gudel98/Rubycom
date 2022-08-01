require 'rspec'
require 'converter'

RSpec.describe Converter do
  
  describe '.to_eur' do
    before { @converter = Converter.new('1.00', 'USD') }
    it 'should display currency conversion in eur' do
      expect(@converter.to_eur).to eq(0.85)
    end
  end

  describe Converter do
    before { @converter = Converter.new('1.00', 'EUR') }
    it 'should display currency conversion in usd' do
      expect(@converter.to_usd).to eq(1.18)
    end
  end

  describe Converter do
    before { @converter = Converter.new('1.00', 'USD') }
    it 'should display currency conversion in rus' do
      expect(@converter.to_rus).to eq(74.17)
    end
  end

  describe Converter do
    before { @converter = Converter.new('1.00', 'USD') }
    it 'should display currency conversion in byn' do
      expect(@converter.to_byn).to eq(2.45)
    end
  end

  describe Converter do
    before { @converter = Converter.convert('1.00', 'USD', 'EUR') }
    it 'should display currency conversion in eur' do
      expect(@converter).to eq(0.85)
    end
  end
end

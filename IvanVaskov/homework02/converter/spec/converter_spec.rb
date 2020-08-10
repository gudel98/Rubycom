require_relative './spec_helper.rb'

describe Converter do

  before :all do
    @data = JSON.parse(File.read('data.json').to_s)
  end

  describe '#initialization' do
    subject { Converter.new(@data) }

    it 'set data attribute' do
      expect(subject.data).to eq @data
    end

    it 'get nil data' do
      expect { Converter.new(nil) }.to raise_error(ArgumentError,
        "'data' can't be nil")
    end
  end

  describe '#convert' do
    subject { Converter.new(@data) }

    context "when 'convert' call with correct arguments" do
      it 'returns array with size = 2' do
        expect(subject.convert(10, 'BYN', 'USD').size).to eq(2)
      end

      it 'returns array with item types are Money' do
        expect(subject.convert(10, 'BYN', 'USD')[0].class).to eq(Money)
      end

      it "returns two equals object if 'from' and 'to' currency are the same" do
        expect(subject.convert(1000, 'BYN', 'BYN')[0]).
          to eq(subject.convert(1000, 'BYN', 'BYN')[1])
      end
    end

    context "when 'convert' call with invalid arguments" do
      it "returns nil if invalid 'from' currency" do
        expect(subject.convert(10, 'BY7', 'USD')).to eq(nil)
      end

      it "returns nil if invalid 'to' currency" do
        expect(subject.convert(10, 'BYN', 'USQ')).to eq(nil)
      end

      it "returns nil if amount less then zero" do
        expect(subject.convert(-1, 'BYN', 'USD')).to eq(nil)
      end

      it "returns nil if amount equals zero" do
        expect(subject.convert(0, 'BYN', 'USD')).to eq(nil)
      end

      it "returns nil if amount not 'Integer'" do
        expect(subject.convert(10.3, 'BYN', 'USD')).to eq(nil)
      end
    end
  end
end

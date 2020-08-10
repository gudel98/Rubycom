require_relative '../lib/converter.rb'
require_relative '../lib/data_provider.rb'
require_relative '../lib/data_utils.rb'

require 'rspec'

=begin
RSpec.describe 'Calculator' do
  describe '.sum' do
    it 'returns sum of two elements' do
      sum = Calculator.new.sum([1, 2])
      expect(sum).to eq(3)
    end
  end

  describe '.mult' do
    let!(:params) { [2, 5] }

    subject(:result) { Calculator.new.mult(params) }

    it 'returns mult of two elements' do
      expect(result[:value]).to eq(10)
    end

    it 'returns two input elements' do
      expect(result[:params].first).to eq(2)
      expect(result[:params].last).to eq(5)
    end

    context 'when third parameter present' do
      before { params << 4 }

      it 'returns mult of three elements' do
        expect(result[:value]).to eq(40)
      end

      it 'returns three input elements' do
        expect(result[:params]).to eq([2, 5, 4])
      end
    end

    context 'when params nil' do
      subject(:result) { Calculator.new.mult }

      it 'returns mult of three elements' do
        expect(result).to be_nil
      end
    end

    context 'with string params' do
      let(:params) { ['1', '3', '5', '7'] }

      it 'returns mult of input params' do
        expect(result[:value]).to eq(105)
      end
    end
  end
=end

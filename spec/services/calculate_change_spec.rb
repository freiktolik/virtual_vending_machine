require_relative '../support/database'

RSpec.describe CalculateChange do
  subject {CalculateChange.call($database.coins, balance)}

  describe '.call' do
    context 'when should return some remaining_change' do
      let(:balance) { 98.00 }
      let(:remaining_change) { 39.25 }
      let(:change_coins) { {5.0=>5, 3.0=>5, 2.0=>5, 1.0=>5, 0.5=>5, 0.25=>5} }

      it 'returns expected change_coins vale' do
        expect(subject).to eq [remaining_change, change_coins]
      end
    end

    context 'when remaining_change equals 0' do
      let(:balance) { 58.50 }
      let(:remaining_change) { 0 }
      let(:change_coins) { {5.0=>5, 3.0=>5, 2.0=>5, 1.0=>5, 0.5=>5, 0.25=>4} }

      it 'returns expected change_coins vale' do
        expect(subject).to eq [remaining_change, change_coins]
      end
    end
  end
end

RSpec.describe Coin do
  let(:value) { 5.0 }
  let(:quantity) { 5 }
  
  subject do
    described_class.new(value, quantity)
  end

  describe '#add' do
    let(:quantity) { 2 }

    it 'increases the coin quantity by 1' do
      expect { subject.add(1) }.to change { subject.quantity }.by(1)
    end
  end

  describe '#deduct' do
    context 'when quantity more than 0' do
      let(:quantity) { 2 }

      it 'reduces the coin quantity by 1' do
        expect { subject.deduct(1) }.to change { subject.quantity }.by(-1)
      end
    end

    context 'when quantity equal 0' do
      let(:quantity) { 0 }

      it 'raises an error' do
        expect { subject.deduct(1) }.to raise_error(VirtualVendingError, Coin::NOT_ENOUGH_COINS)
      end
    end
  end
end

RSpec.describe Product do
  let(:name) { 'orange juice' }
  let(:price) { 2.7 }
  
  subject do
    described_class.new(name, price, quantity)
  end

  describe '#in_stock?' do
    context 'when quantity more than 0' do
      let(:quantity) { 3 }

      it 'returns true' do
        expect(subject.in_stock?).to be true
      end
    end

    context 'when quantity equal 0' do
      let(:quantity) { 0 }

      it 'returns true' do
        expect(subject.in_stock?).to be false
      end
    end
  end

  describe '#buy!' do
    context 'when the product is in stock' do
      let(:quantity) { 3 }

      it 'reduces the product quantity by 1' do
        expect { subject.buy! }.to change { subject.quantity }.by(-1)
      end
    end

    context 'when a product is out of stock' do
      let(:quantity) { 0 }

      it 'raises an error' do
        expect { subject.buy! }.to raise_error(InputError, Product::OUT_OF_STOCK)
      end
    end
  end
end

RSpec.describe CheckoutOrder do
  let!(:coca_cola) {Product.new('coca cola', 2.0, 2) }
  let!(:fanta) {Product.new('fanta', 2.7, 3) }
  let!(:sprite) {Product.new('sprite', 2.5, 2) }
  let!(:water) {Product.new('water', 3.25, 0) }
  let(:deposited_amount) { 7 }
  
  subject { described_class.new() }

  before do
    subject.deposited_amount = deposited_amount
    subject.products << fanta
    subject.products << sprite
  end

  describe '#balance' do
    it 'returns expected balance value' do
      expect(subject.balance).to eq 1.8
    end
  end

  describe '#enable_purchase?' do
    context 'when user have enough balance to buy a products' do
      it 'returns true' do
        expect(subject.enable_purchase?).to eq true
      end
    end

    context 'when user does not have enough balance to buy a products' do

      before { subject.products << coca_cola }

      it 'returns false' do
        expect(subject.enable_purchase?).to eq false
      end
    end
  end

  describe '#purchase_price' do
    it 'returns the total purchase price' do
      expect(subject.purchase_price).to eq 5.2
    end
  end

  describe '#change' do
    let(:coins) { [Coin.new(5.0, 5), Coin.new(2.0, 5)]}
    
    before do
      allow(CalculateChange).to receive(:call)
    end

    it 'calls CalculateChange with expect parameters' do
      subject.change(coins)
      expect(CalculateChange).to have_received(:call).with(coins, subject.balance)
    end
  end
end

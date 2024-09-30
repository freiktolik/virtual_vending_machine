require_relative '../support/database'

RSpec.describe Database do
  
  describe '#product_rows' do
    let(:some_product_attributes) { ['fanta', 2.7, 3] }

    it 'returns an array of arrays with product attributes' do
      expect($database.product_rows).to include(some_product_attributes)
    end
  end

  describe '#find_product' do
    context 'when user does not select any products' do
      let(:name) { '' }
      
      it 'raises an InputError error' do
        expect { $database.find_product(name) }.to raise_error(InputError, Product::EMPTY)
      end
    end

    context 'when product unavailable' do
      let(:name) { 'some' }
      let(:error_message) {"There is no product: #{name} in vending machine, please select another one:\n"}

      it 'raises an InputError error' do
        expect { $database.find_product(name) }.to raise_error InputError
      end
    end

    context 'when a product is out of stock' do
      let(:name) { 'water' }

      it 'raises an InputError error' do
        expect { $database.find_product(name) }.to raise_error InputError
      end
    end

    context 'when product available' do
      let(:name) { 'fanta' }

      it 'returns product' do
        expect($database.find_product(name)).to be_an(Product)
      end 
    end
  end

  describe '#find_coin' do
    context 'when user does not enter any coin' do
      let(:value) { 0.0 }
      
      it 'raises an InputError error' do
        expect { $database.find_coin(value) }.to raise_error InputError
      end
    end

    context 'when coin unavailable' do
      let(:value) { 7.0 }

      it 'raises an InputError error' do
        expect { $database.find_coin(value) }.to raise_error InputError
      end
    end

    context 'when coin available' do
      let(:value) { 2 }

      it 'returns coins' do
        expect($database.find_coin(value)).to be_an(Coin)
      end 
    end
  end
end

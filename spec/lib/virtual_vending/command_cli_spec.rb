RSpec.describe VirtualVending::CommandCLI do
  let(:database) { instance_double("Database") }
  let(:service) { instance_double("CheckoutOrder", deposited_amount: 0.0, products: []) }
  let(:stream) { instance_double("InputOutputHandler") }

  before do
     allow(InputOutputHandler).to receive(:new).and_return(stream)
     allow(stream).to receive(:print_output)
     allow(stream).to receive(:read_input)
  end

  subject { described_class.new(service) }

  describe '#initialize' do
    it 'sets up the @service with the transaction argument' do
      expect(subject.instance_variable_get(:@service)).to eq(service)
    end

    it 'initializes @stream with a new InputOutputHandler' do
      expect(subject.instance_variable_get(:@stream)).to eq(stream)
    end
  end

  describe '#call' do
    before do
      allow(subject).to receive(:initialize_virtual_vending_machine)
      allow(subject).to receive(:virtual_vending_machine_menu)
    end

    it 'calls #initialize_virtual_vending_machine and #virtual_vending_machine_menu' do
      subject.call

      expect(subject).to have_received(:initialize_virtual_vending_machine).once
      expect(subject).to have_received(:virtual_vending_machine_menu).once
    end
  end

  describe '#initialize_virtual_vending_machine' do
    let(:initialization_message) { 'VM is initialized with default following set of products'.to_yellow }

    before { allow($database).to receive(:product_rows).and_return([['fanta', 2.7, 3]]) }
    
    it 'prints the initialization message' do
      expect(stream).to receive(:print_output).with(initialization_message)
      subject.send(:initialize_virtual_vending_machine)
    end

    it 'calls #product_rows on $database' do
      subject.send(:initialize_virtual_vending_machine)
      expect($database).to have_received(:product_rows)
    end
  end

  describe '#virtual_vending_machine_menu' do
    let(:select_menu_option_message) do "Please Choose From the Following Options:\n\
      1. Enter Coins\n\
      2. Buy Product\n\
      3. Get the Change\n" 
    end

    before do
       allow(subject).to receive(:user_vending_machine_balance)
       allow(subject).to receive(:menu_choose_action)
    end
    
    it 'prints the user vending machine menu option' do
      expect(stream).to receive(:print_output).with(select_menu_option_message)
      subject.send(:virtual_vending_machine_menu)
    end

    it 'calls #user_vending_machine_balance' do
      subject.send(:virtual_vending_machine_menu)
      expect(subject).to have_received(:user_vending_machine_balance)
    end
  end

  describe '#user_vending_machine_balance' do
    let(:vending_machine_balance_message) { "On your balance is: #{balance.to_s.to_yellow}$ \n"}
    let(:balance) { 7.3 }
    
    before { allow(service).to receive(:balance).and_return(balance) }
    
    it 'prints the user vending machine balance message' do
      subject.send(:user_vending_machine_balance)
      expect(stream).to have_received(:print_output).with(vending_machine_balance_message)
    end
  end

  describe '#menu_choose_action' do
    context 'when choosing option 1' do
      before do
        allow(stream).to receive(:read_input).and_return(1)
        allow(subject).to receive(:insert_coins)
      end

      it 'calls #insert_coins' do
        subject.send(:menu_choose_action)
        expect(subject).to have_received(:insert_coins).once
      end
    end

    context 'when choosing option 2' do
      before do
        allow(stream).to receive(:read_input).and_return(2)
        allow(subject).to receive(:select_and_buy_product)
      end

      it 'calls #select_and_buy_product' do
        subject.send(:menu_choose_action)
        expect(subject).to have_received(:select_and_buy_product).once
      end
    end

    context 'when choosing option 3' do
      before do
        allow(stream).to receive(:read_input).and_return(3)
        allow(subject).to receive(:complete_purchase)
      end

      it 'calls #complete_purchase' do
        subject.send(:menu_choose_action)
        expect(subject).to have_received(:complete_purchase).once
      end
    end
  end

  describe '#insert_coins' do
    let(:service) { CheckoutOrder.new(deposited_amount: 0.0) }
    let(:coin) { Coin.new(2.0, 5) }

    context 'when coin is valid' do
      before do
        allow(subject).to receive(:virtual_vending_machine_menu)
        allow(stream).to receive(:read_input).and_return(2)
        allow($database).to receive(:find_coin).and_return(coin)
      end

      it 'calls #virtual_vending_machine_menu again' do
        subject.send(:insert_coins)
        expect(subject).to have_received(:virtual_vending_machine_menu).once
      end

      it 'adds the coin value to service.deposited_amount' do
        expect { subject.send(:insert_coins) }.to change { service.deposited_amount }.by(2.0)
      end
    end
  end

  describe '#select_and_buy_product' do
    context 'when product is available' do
      let!(:product) {Product.new('sprite', 2.5, 2) }

      before do
        allow(subject).to receive(:virtual_vending_machine_menu)
        allow(subject).to receive(:buying_product)
        allow(stream).to receive(:read_input).and_return('sprite')
        allow($database).to receive(:find_product).and_return(product)
      end


      it 'calls #buying_product' do
        subject.send(:select_and_buy_product)
        expect(subject).to have_received(:buying_product).with(product).once
      end

      it 'calls #virtual_vending_machine_menu' do
        subject.send(:select_and_buy_product)
        expect(subject).to have_received(:virtual_vending_machine_menu).once
      end
    end
  end


  describe '#buying_product' do
    let!(:product) {Product.new('sprite', 2.5, 2) }

    context 'when purchase enable' do
      before do
        allow(service).to receive(:enable_purchase?).and_return(true)
      end

      it 'adds product to the transaction' do
        subject.send(:buying_product, product)
        expect(service.products).to include product
      end

      it 'calls #buy on product' do
        subject.send(:buying_product, product)
        expect(product.quantity).to eq 1
      end
    end
  
    context 'when purchase denied' do
      let(:balance) { 7.3 }

      before do
        allow(subject).to receive(:virtual_vending_machine_menu)
        allow(service).to receive(:enable_purchase?).and_return(false)
        allow(service).to receive(:balance).and_return(balance)
      end

      it 'calls #virtual_vending_machine_menu again' do
        subject.send(:buying_product, product)
        expect(subject).to have_received(:virtual_vending_machine_menu).once
      end
    end
  end

  describe '#complete_purchase' do
    let(:change_coins) { {5.0=>5, 3.0=>5, 2.0=>5, 1.0=>5, 0.5=>5, 0.25=>4} }
    let(:thanks_message) { 'Thank you for using our Virtual Vending. Good-Bye!' }
    let(:change_message) { "#{"Your change:".to_yellow} #{subject.send(:returned_coins, change_coins)}" }
    
    before { allow(service).to receive(:change).and_return([0, change_coins]) }

    it 'returns the correct change coins message' do
      subject.send(:complete_purchase)
      expect(stream).to have_received(:print_output).with(thanks_message)
      expect(stream).to have_received(:print_output).with(change_message)
    end
  end
end

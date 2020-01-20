describe API do
  describe 'when forex functions are used' do
    describe 'when "CURRENCY_EXCHANGE_RATE" function is used' do
      before do 
        ENV['ALPHA_VANTAGE_API_KEY'] = 'demo'
        @supposed_hash_object = ::API::get_directly(function: "CURRENCY_EXCHANGE_RATE", from_currency: "USD", to_currency: "JPY")
      end 

      it 'must return a Hash object' do
        _(@supposed_hash_object).must_be_kind_of Hash
      end
    end

    describe 'when the "FX_INTRADAY" function is used' do
      before do 
        @supposed_hash_object = ::API::get_directly(function: "FX_INTRADAY", from_symbol: "EUR", to_symbol: "USD", interval: "5min")
      end

      it 'must return a Hash object' do 
      _(@supposed_hash_object).must_be_kind_of Hash
      end
    end

    describe 'when the "FX_DAILY" function is used' do
      before do 
        @supposed_hash_object = ::API::get_directly(function: "FX_DAILY", from_symbol: "EUR", to_symbol: "USD", outputsize: "full")
      end

      it 'must return a Hash object' do 
      _(@supposed_hash_object).must_be_kind_of Hash
      end
    end
  end
end
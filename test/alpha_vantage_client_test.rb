require "test_helper"
require 'alpha_vantage_client/api.rb'

class AlphaVantageClientTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::AlphaVantageClient::VERSION
  end
end

describe API do
  describe 'when forex functions are used' do
    describe 'when "CURRENCY_EXCHANGE_RATE" function is used' do
      before do 
        @supposed_hash_object = API::get_directly(function: "CURRENCY_EXCHANGE_RATE", from_currency: "USD", to_currency: "BTC")
      end 

      it 'must return a Hash object' do
        _(@supposed_hash_object).must_be_kind_of Hash
      end
    end

    describe 'when the "FX_INTRADAY" function is used' do
      before do 
        @supposed_hash_object = API::get_directly(function: "FX_INTRADAY", from_symbol: "USD", to_symbol: "TWD", interval: "5min")
      end

      it 'must return a Hash object' do 
      _(@supposed_hash_object).must_be_kind_of Hash
      end
    end

    describe 'when the "FX_DAILY" function is used' do
      before do 
        @supposed_hash_object = API::get_directly(function: "FX_DAILY", from_symbol: "AUD", to_symbol: "USD", outputsize: "full")
      end

      it 'must return a Hash object' do 
      _(@supposed_hash_object).must_be_kind_of Hash
      end
    end
  end
end
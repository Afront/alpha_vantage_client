#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pp'

describe API do
  describe 'when forex functions are used' do
    describe 'when "CURRENCY_EXCHANGE_RATE" function is used' do
      before do
        @supposed_hash_object = ::API.get_directly(function: 'CURRENCY_EXCHANGE_RATE', from_currency: 'USD', to_currency: 'JPY')
      end

      it 'must return a Hash object' do
        _(@supposed_hash_object).must_be_kind_of Hash
      end
    end

    describe 'when the "FX_INTRADAY" function is used' do
      before do
        @supposed_hash_object = ::API.get_directly(function: 'FX_INTRADAY', from_symbol: 'EUR', to_symbol: 'USD', interval: '5min')
      end

      it 'must return a Hash object' do
        _(@supposed_hash_object).must_be_kind_of Hash
      end
    end

    describe 'when the "FX_DAILY" function is used' do
      before do
        @supposed_hash_object = ::API.get_directly(function: 'FX_DAILY', from_symbol: 'EUR', to_symbol: 'USD', outputsize: 'full')
      end

      it 'must return a Hash object' do
        _(@supposed_hash_object).must_be_kind_of Hash
      end
    end
  end

  describe 'when crypto functions are used' do
    describe 'when "CURRENCY_EXCHANGE_RATE" function is used' do
      before do
        @supposed_hash_object = ::API.get_directly(function: 'CURRENCY_EXCHANGE_RATE', from_currency: 'BTC', to_currency: 'CNY')
      end

      it 'must return a Hash object' do
        _(@supposed_hash_object).must_be_kind_of Hash
      end
    end

    describe 'when the "DIGITAL_CURRENCY_DAILY" function is used' do
      before do
        @supposed_hash_object = ::API.get_directly(function: 'DIGITAL_CURRENCY_DAILY', symbol: 'BTC', market: 'CNY')
      end

      it 'must return a Hash object' do
        _(@supposed_hash_object).must_be_kind_of Hash
      end
    end

    describe 'when the "DIGITAL_CURRENCY_WEEKLY" function is used' do
      before do
        @supposed_hash_object = ::API.get_directly(function: 'DIGITAL_CURRENCY_WEEKLY', symbol: 'BTC', market: 'CNY')
      end

      it 'must return a Hash object' do
        _(@supposed_hash_object).must_be_kind_of Hash
      end
    end

    describe 'when the "DIGITAL_CURRENCY_MONTHLY" function is used' do
      before do
        @supposed_hash_object = ::API.get_directly(function: 'DIGITAL_CURRENCY_MONTHLY', symbol: 'BTC', market: 'CNY')
      end

      it 'must return a Hash object' do
        _(@supposed_hash_object).must_be_kind_of Hash
      end
    end
  end
  describe 'when sector functions are used' do
    describe 'when "SECTOR" function is used' do
      before do
        @supposed_hash_object = ::API.get_directly(function: 'SECTOR')
      end

      it 'must return a Hash object' do
        _(@supposed_hash_object).must_be_kind_of Hash
      end
    end
  end
end

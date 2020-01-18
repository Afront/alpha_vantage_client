require "test_helper"
require 'alpha_vantage_client/api.rb'

class AlphaVantageClientTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::AlphaVantageClient::VERSION
  end

  def test_for_printing_json
    API::test(function: "CURRENCY_EXCHANGE_RATE", from_currency: "USD", to_currency: "BTC")
    API::test(function: "FX_INTRADAY", from_symbol: "USD", to_symbol: "TWD", interval: "5min")
    API::test(function: "FX_DAILY", from_symbol: "USD", to_symbol: "ZWL", outputsize: "full")
  end
end
require "test_helper"

class AlphaVantageClientTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::AlphaVantageClient::VERSION
  end

  def test_for_printing_json
    API::test(function: "CURRENCY_EXCHANGE_RATE", from_currency: "USD", to_currency: "TWD")
  end
end
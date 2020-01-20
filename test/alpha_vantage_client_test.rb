require "test_helper"

describe AlphaVantageClient do
  it 'must have a version number' do
    refute_nil ::AlphaVantageClient::VERSION
  end
end

require 'api_spec'
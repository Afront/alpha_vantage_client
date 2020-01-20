require "test_helper"

describe AlphaVantageClient do
  it 'must have a version number' do
    refute_nil ::AlphaVantageClient::VERSION
  end
end

if ENV['ALPHA_VANTAGE_API_KEY'] == 'demo'
  require 'api_spec_demo'
else
  require 'api_spec'  
end

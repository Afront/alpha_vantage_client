# frozen_string_literal: true

require 'test_helper'
require 'api_spec_demo'

describe AlphaVantageClient do
  it 'must have a version number' do
    refute_nil ::AlphaVantageClient::VERSION
  end
end

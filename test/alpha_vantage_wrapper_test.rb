# frozen_string_literal: true

require 'test_helper'
require 'api_spec_demo'

describe AlphaVantageWrapper do
  it 'must have a version number' do
    refute_nil ::AlphaVantageWrapper::VERSION
  end
end

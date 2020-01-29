#!/usr/bin/env ruby
# frozen_string_literal: true

require 'alpha_vantage_client/version'
require 'alpha_vantage_client/api.rb'

# (TODO:) Add documentation
module AlphaVantageClient
  class Error < StandardError; end
  include API
end

#!/usr/bin/env ruby
# frozen_string_literal: true

require 'alpha_vantage_wrapper/version'
require 'alpha_vantage_wrapper/api.rb'

# (TODO:) Add documentation
module AlphaVantageWrapper
  class Error < StandardError; end
  include API
end

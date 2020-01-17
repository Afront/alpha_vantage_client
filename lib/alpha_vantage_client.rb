require "alpha_vantage_client/version"
require 'alpha_vantage_client/api.rb'

module AlphaVantageClient
  class Error < StandardError; end
  include API
end
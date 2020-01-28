require 'faraday'
require 'json'
require 'toml-rb'

module API
  raise IOError, 'ALPHA_VANTAGE_API_KEY is not set as an environmental variable. If you want to load the API key youself, load API_KEY first' if ENV['ALPHA_VANTAGE_API_KEY'].nil?
  API_KEY = ENV['ALPHA_VANTAGE_API_KEY'].to_s
  #TODO: allow api key loading

  #TODO: add functions_info for this module

  module_function
  #TODO: allow implicit loading 

  def load type
    begin
      send type
    rescue
      raise NameError, `There is no type of functions with that name. The only valid types are "crypto", "forex", "lazy", "sector", "stocks", and "tech_indicators"`
    end
  end

  def crypto
    require ''
  end

  def forex

  end

  def lazy
    require_relative 'lazy'
    include Lazy
    extend Lazy::LazyMethods 
  end

  def sector

  end

  def stocks

  end

  def tech_indicators

  end
end
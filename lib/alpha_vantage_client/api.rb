# frozen_string_literal: true

require 'faraday'
require 'json'
require 'toml-rb'

# (TODO:) Add documentation here
module API
  API_KEY = ENV['ALPHA_VANTAGE_API_KEY'].to_s

  # A class for functions_info; originally a struct, but changed it to class
  class FunctionsInfo
    def initialize
      @info = {}
    end

    def optional_parameter?(function, parameter)
      @info[function]['optional'].include? parameter
    end

    def required_parameter?(function, parameter)
      @info[function]['required'].include? parameter
    end

    def parameter?(function, parameter)
      parameters(function).include? parameter
    end

    def include?(function)
      !@info[function].nil?
    end

    def parameters(function)
      @info[function]['required'] + @info[function]['optional']
    end

    def not_loaded
      @info.empty?
    end

    def load(type)
      # rubocop:disable Style/RedundantBegin
      begin
        @info.merge! TomlRB.load_file("lib/alpha_vantage_client/#{type}.toml")
      rescue LoadError
        raise NameError, ["This function type, #{type}, does not exist.",
                          'The only valid types are "all", "crypto", "forex",',
                          '"sector", "stocks", and "tech_indicators"'].join(' ')
      end
      # rubocop:enable Style/RedundantBegin
    end

    def info(function)
      @info[function]
    end
  end

  @functions_info = FunctionsInfo.new

  module_function

  def load(type)
    @functions_info.load type
  end

  # This module contains specific methods
  # and a general method for cryptocurrencies
  module Crypto
  end

  # This module contains specific methods
  # and a general method for forex (fx)
  module Forex
  end

  # This module contains a method for sector
  module Sector
  end

  # This module contains specific methods
  # and a general method for stocks
  module Stocks
  end

  # This module contains specific methods
  # and a general method for stocks
  module TechIndicators
  end

  def generate_url(hash, arr_err = [], valid_string = '')
    hash.each_pair do |parameter, value|
      # assumes all values are not nil
      # add raise ''... if hash contains nil as a value
      valid_string += "#{parameter}=#{value}"
      if @functions_info.parameter?(hash[:function], parameter)
        arr_err << "#{parameter} should not be set for #{hash[:function]}"
      elsif @functions_info.required_parameter?(hash[:function], parameter)
        arr_err << "#{parameter} is not set"
      end
    end

    raise ArgumentError, "#{arr_err.join("\n\t\t")}\n" unless arr_err.empty?

    "https://www.alphavantage.co/query?#{valid_string}&apikey=#{hash[:apikey]}"
  end

  def get_json(call_hash)
    json_result = Faraday.get generate_url(call_hash)
    JSON.parse json_result.body
  end

  def print_json(json, depth = 0)
    json.each do |key, value|
      if value.is_a? Hash
        puts "#{key}:"
        print_json value, depth + 1
      else
        puts "#{"\t" * depth}#{key}: #{value}"
      end
    end
  end

  def get_directly(**kwargs)
    function = kwargs[:function]
    invalid_function_w = "Invalid function: #{function}"
    unset_key_warning = "The API key is not set! Please set the API key \
either as an argument for this method or \
as an environmental variable (ALPHA_VANTAGE_API_KEY)"

    @functions_info.load 'all' if @functions_info.not_loaded
    raise NameError, invalid_function_w unless @functions_info.include? function
    raise ArgumentError, unset_key_warning unless kwargs[:apikey] ||= API_KEY

    get_json(kwargs)
  end

  def print_directly(**kwargs)
    print_json get_json(kwargs)
  end
end

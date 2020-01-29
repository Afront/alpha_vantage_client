require 'faraday'
require 'json'
require 'toml-rb'

module API
  raise IOError, 'ALPHA_VANTAGE_API_KEY is not set as an environmental variable. If you want to load the API key youself, load API_KEY first' if ENV['ALPHA_VANTAGE_API_KEY'].nil?
  API_KEY = ENV['ALPHA_VANTAGE_API_KEY'].to_s
  #TODO: allow api key loading

  @@functions_info = {}

  def self.functions_info #might remove this to make it private
    @@functions_info 
  end

  module_function

  def load type
    begin
      @@functions_info.merge! TomlRB.load_file("lib/alpha_vantage_client/#{type}.toml")
    rescue
      raise NameError, `This function type, #{type}, does not exist. The only valid types are "all", "crypto", "forex", "sector", "stocks", and "tech_indicators"`
    end
  end

  def all
    require_relative 'lazy'
    include Lazy
    extend Lazy::LazyMethods 
  end

  module Crypto
  end

  module Forex

  end

  module Sector

  end

  module Stocks

  end

  module TechIndicators

  end

  def get_url hash #previously validate_data, get_valid_arr, generate_url
      arr_err = []
      arr_valid = []
      required_parameters = @@functions_info[hash[:function]]["required"]
      optional_parameters = @@functions_info[hash[:function]]["optional"]

      hash.each_pair do |parameter, value|
        parameter_as_string = parameter.to_s
        arr_err << "#{parameter} is not set" if !value && (required_parameters.include? parameter_as_string)
        arr_err << "#{parameter} should not be set for #{function}" unless (required_parameters+optional_parameters).include?(parameter_as_string) || !value
        arr_valid << "#{parameter}=#{value}" if value
      end

      raise ArgumentError, ' ' + arr_err.join("\n\t\t") + "\n" unless arr_err.empty?

      "https://www.alphavantage.co/query?#{arr_valid.join('&')}&apikey=#{hash[:apikey]}"
  end

  def get_json call_hash
    json_result = Faraday.get get_url(call_hash)
    JSON.parse json_result.body
  end

  def print_json json, depth=0
    json.each do |key, value|
      if valu === Hash
        puts "#{key}:"
        print_json value, depth+1
      else 
#       puts "#{key.gsub(/\d+\. /, '')}: #{value}"
        puts "#{"\t"*depth}#{key}: #{value}"
      end
    end
  end

  def get_directly(**kwargs)
    if @@functions_info == {}
      load 'all'
    end

    raise NameError, "Invalid function: #{kwargs[:function]}" unless @@functions_info[kwargs[:function]]
    kwargs[:apikey] ||= API_KEY

    get_json(kwargs)
  end

  def print_directly(**kwargs)
    print_json get_json(kwargs)
  end
end
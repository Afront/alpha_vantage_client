require 'faraday'
require 'json'
require 'toml-rb'

# (TODO:) Add documentation here
module API
  API_KEY = ENV['ALPHA_VANTAGE_API_KEY'].to_s

  @functions_info = {}

  #might remove this to make it private
  def self.functions_info 
    @functions_info
  end

  module_function

  def load type
    begin
      @functions_info.merge! TomlRB.load_file("lib/alpha_vantage_client/#{type}.toml")
    rescue
      raise NameError, `This function type, #{type}, does not exist. 
                        The only valid types are "all", "crypto", "forex", 
                        "sector", "stocks", and "tech_indicators"`
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

  def generate_url(hash)
      arr_err = []
      arr_valid = []
      required_parameters = @functions_info[hash[:function]]['required']
      optional_parameters = @functions_info[hash[:function]]['optional']

      hash.each_pair do |parameter, value|
        para_string = parameter.to_s
        not_set = !value && (required_parameters.include? para_string)
        should_be_set = (required_parameters+optional_parameters).include?(para_string) || !value
        arr_err << "#{parameter} is not set" if not_set
        arr_err << "#{parameter} should not be set for #{function}" unless should_be_set
        arr_valid << "#{parameter}=#{value}" if value
      end

      raise ArgumentError,  "#{arr_err.join("\n\t\t")}\n" unless arr_err.empty?

      "https://www.alphavantage.co/query?#{arr_valid.join('&')}&apikey=#{hash[:apikey]}"
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
#       puts "#{key.gsub(/\d+\. /, '')}: #{value}"
        puts "#{"\t" * depth}#{key}: #{value}"
      end
    end
  end

  def get_directly(**kwargs)
    unset_key_warning = "The API key is not set! Please set the API key \
either as an argument for this method or \
as an environmental variable (ALPHA_VANTAGE_API_KEY)"

    load 'all' if @functions_info == {}
    not_in_info = @functions_info[kwargs[:function]].nil?

    raise NameError, "Invalid function: #{kwargs[:function]}" if not_in_info
    raise ArgumentError, unset_key_warning unless kwargs[:apikey] ||= API_KEY

    get_json(kwargs)
  end

  def print_directly(**kwargs)
    print_json get_json(kwargs)
  end
end

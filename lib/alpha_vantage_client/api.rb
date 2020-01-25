require 'faraday'
require 'json'
require 'toml-rb'

module API
  raise IOError, 'ALPHA_VANTAGE_API_KEY is not set as an environmental variable' if ENV['ALPHA_VANTAGE_API_KEY'].nil?
  API_KEY = ENV['ALPHA_VANTAGE_API_KEY'].to_s
  
  @@functions_info = TomlRB.load_file('lib/alpha_vantage_client/api.toml')

  def self.functions_info #might remove this to make it private
    @@functions_info 
  end


  CallStruct = Struct.new(:function, :from_currency, :to_currency, :from_symbol, :to_symbol, :symbol, :market, :interval, :outputsize, :datatype, :keywords, keyword_init: true) do
    def get_url #previously validate_data, get_valid_arr, generate_url
      arr_err = []
      arr_valid = []

      required_parameters = @@functions_info[function]["required"]
      optional_parameters = @@functions_info[function]["optional"]

      self.each_pair do |parameter, value|
        parameter_as_string = parameter.to_s
        arr_err << "#{parameter} is not set" if !value && (required_parameters.include? parameter_as_string)
        arr_err << "#{parameter} should not be set for #{function}" unless (required_parameters+optional_parameters).include?(parameter_as_string) || !value
        arr_valid << "#{parameter}=#{value}" if value
      end

      raise ArgumentError, ' ' + arr_err.join("\n\t\t") + "\n" unless arr_err.empty?

      'https://www.alphavantage.co/query?' + arr_valid.join('&') + '&apikey=' + API_KEY
    end
  end

  module_function 

  def get_json call_struct
    json_result = Faraday.get call_struct.get_url
    JSON.parse json_result.body
  end

  def print_json json, depth=0
    json.each do |key, value|
      if value.class == Hash
        puts "#{key}:"
        print_json value, depth+1
      else 
#        puts "#{key.gsub(/\d+\. /, '')}: #{value}"
        puts "#{"\t"*depth}#{key}: #{value}"
      end
    end
  end

  def get_directly(function:, from_currency: false, to_currency: false, from_symbol: false, to_symbol: false, symbol: false, market: false, interval: false, outputsize: false, datatype: false, keywords: false)
    raise NameError, "Invalid function: #{function}" unless @@functions_info[function] 
    get_json CallStruct.new(function: function, from_currency: from_currency, to_currency: to_currency, from_symbol: from_symbol, to_symbol: to_symbol, symbol: symbol, market: market, interval: interval, outputsize: outputsize, datatype: datatype, keywords: keywords)
  end

  def print_directly(function:, from_currency: false, to_currency: false, from_symbol: false, to_symbol: false, symbol: false, market: false, interval: false, outputsize: false, datatype: false, keywords: false)
    call = case @function_type[function]
    when :stock_market_function
      CallStruct.new(function: function, symbol: symbol, interval: interval, outputsize:outputsize, datatype: datatype, keywords: keywords)
    when :forex_function      
      CallStruct.new(function: function, from_currency: from_currency, to_currency: to_currency, from_symbol: from_symbol, to_symbol: to_symbol, interval: interval, outputsize: outputsize, datatype: datatype)
    when :crypto_function
      CallStruct.new(function: function, symbol: symbol, market: market, datatype: datatype)  
    when :sector_function
      CallStruct.new(function: function)  
    else 
      raise NameError, "Invalid function: #{function}"
    end
    print_json get_json(call)
  end
end
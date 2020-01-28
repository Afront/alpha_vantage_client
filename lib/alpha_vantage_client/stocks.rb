module Stocks
  API_KEY = ::API::API_KEY

  #TODO: Instead of assigning the hash here, merge it to a hash in api.rb
  @@functions_info = TomlRB.load_file('lib/alpha_vantage_client/stocks.toml')

  def self.functions_info #might remove this to make it private
    @@functions_info 
  end

  CallStruct = Struct.new(:function, :symbol, :interval, :outputsize, :datatype, :keywords, :apikey, keyword_init: true) do
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

  module StockMethods #TODO: Refactor it to satisfy DRY, especially get_json and print_json (these two should be in a different module as well)
    def self.functions_info #might remove this to make it private
      Stocks::functions_info #TODO: Change to api.rb's functions_info
    end

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

    def get_directly(function:, symbol: false, market: false, interval: false, outputsize: false, datatype: false, keywords: false, apikey: false)
      raise NameError, "Invalid function: #{function}" unless Lazy::functions_info[function] 
      apikey = API_KEY unless apikey
      get_json CallStruct.new(function: function, symbol: symbol, market: market, apikey: apikey, outputsize: outputsize, datatype: datatype, from_symbol: from_symbol, to_symbol: to_symbol, interval: interval, from_currency: from_currency, to_currency: to_currency, fastperiod: fastperiod, slowperiod: slowperiod, time_period: time_period, matype: matype, series_type: series_type, nbdevup: nbdevup, nbdevdn: nbdevdn, signalperiod: signalperiod, fastmatype: fastmatype, slowmatype: slowmatype, signalmatype: signalmatype, fastlimit: fastlimit, slowlimit: slowlimit, acceleration: acceleration, maximum: maximum, fastkperiod: fastkperiod, slowkperiod: slowkperiod, slowdperiod: slowdperiod, slowkmatype: slowkmatype, slowdmatype: slowdmatype, fastdperiod: fastdperiod, fastdmatype: fastdmatype, keywords: keywords, timeperiod1: timeperiod1, timeperiod2: timeperiod2, timeperiod3: timeperiod3)
    end

    def print_directly(function:, symbol: false, market: false, interval: false, outputsize: false, datatype: false, keywords: false, apikey: false)
      raise NameError, "Invalid function: #{function}" unless Lazy::functions_info[function] 
      apikey = API_KEY unless apikey
      print_json get_json(CallStruct.new(function: function, symbol: symbol, market: market, apikey: apikey, outputsize: outputsize, datatype: datatype, from_symbol: from_symbol, to_symbol: to_symbol, interval: interval, from_currency: from_currency, to_currency: to_currency, fastperiod: fastperiod, slowperiod: slowperiod, time_period: time_period, matype: matype, series_type: series_type, nbdevup: nbdevup, nbdevdn: nbdevdn, signalperiod: signalperiod, fastmatype: fastmatype, slowmatype: slowmatype, signalmatype: signalmatype, fastlimit: fastlimit, slowlimit: slowlimit, acceleration: acceleration, maximum: maximum, fastkperiod: fastkperiod, slowkperiod: slowkperiod, slowdperiod: slowdperiod, slowkmatype: slowkmatype, slowdmatype: slowdmatype, fastdperiod: fastdperiod, fastdmatype: fastdmatype, keywords: keywords, timeperiod1: timeperiod1, timeperiod2: timeperiod2, timeperiod3: timeperiod3))
    end
  end
end
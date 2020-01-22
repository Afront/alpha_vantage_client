require 'faraday'
require 'json'

module API
  raise IOError, 'ALPHA_VANTAGE_API_KEY is not set as an environmental variable' if ENV['ALPHA_VANTAGE_API_KEY'].nil?
  API_KEY = ENV['ALPHA_VANTAGE_API_KEY'].to_s
  
  @function_type = {
        "TIME_SERIES_INTRADAY"=> :stock_market_function,
        "TIME_SERIES_DAILY"=> :stock_market_function,
        "TIME_SERIES_DAILY_ADJUSTED"=> :stock_market_function,
        "TIME_SERIES_WEEKLY"=> :stock_market_function,
        "TIME_SERIES_WEEKLY_ADJUSTED"=> :stock_market_function,
        "TIME_SERIES_MONTHLY"=> :stock_market_function,
        "TIME_SERIES_MONTHLY_ADJUSTED"=> :stock_market_function,
        "QUOTE_ENDPOINT"=> :stock_market_function,
        "SEARCH_ENDPOINT"=> :stock_market_function,
        "CURRENCY_EXCHANGE_RATE"=> :forex_function, #also a crypto function, but DRY...will change this when refactoring
        "FX_INTRADAY"=> :forex_function,
        "FX_DAILY"=> :forex_function,
        "FX_WEEKLY"=> :forex_function,
        "FX_MONTHLY"=> :forex_function,     
        "DIGITAL_CURRENCY_DAILY"=> :crypto_function,
        "DIGITAL_CURRENCY_WEEKLY"=> :crypto_function,
        "DIGITAL_CURRENCY_MONTHLY"=> :crypto_function,     
  }

  CallStruct = Struct.new(:function, :from_currency, :to_currency, :from_symbol, :to_symbol, :symbol, :market, :interval, :outputsize, :datatype, :keywords, keyword_init: true) do
    def get_url #previously validate_data, get_valid_arr, generate_url
      @stock_market_parameters = {
        "TIME_SERIES_INTRADAY"=> {:required => [function, symbol, interval], :optional => [outputsize, datatype]}, 
        "TIME_SERIES_DAILY"=> {:required => [function, symbol], :optional => [outputsize, datatype]},  
        "TIME_SERIES_DAILY_ADJUSTED"=> {:required => [function, symbol], :optional => [outputsize, datatype]},
        "TIME_SERIES_WEEKLY"=> {:required => [function, symbol], :optional => [datatype]},
        "TIME_SERIES_WEEKLY_ADJUSTED"=> {:required => [function, symbol], :optional => [datatype]},
        "TIME_SERIES_MONTHLY"=> {:required => [function, symbol], :optional => [datatype]},
        "TIME_SERIES_MONTHLY_ADJUSTED"=> {:required => [function, symbol], :optional => [datatype]},
        "QUOTE_ENDPOINT"=> {:required => [function, symbol], :optional => [datatype]},
        "SEARCH_ENDPOINT"=> {:required => [function, keywords], :optional => [datatype]}
      }

      @forex_parameters = {
            "CURRENCY_EXCHANGE_RATE"=> {:required => [function, from_currency, to_currency], :optional => []}, 
            "FX_INTRADAY"=> {:required => [function, from_symbol, to_symbol, interval], :optional => [outputsize, datatype]},  
            "FX_DAILY"=> {:required => [function, from_symbol, to_symbol], :optional => [outputsize, datatype]},
            "FX_WEEKLY"=> {:required => [function, from_symbol, to_symbol], :optional => [datatype]},
            "FX_MONTHLY"=> {:required => [function, from_symbol, to_symbol], :optional => [datatype]}
      }

      @crypto_parameters = {
            "DIGITAL_CURRENCY_INTRADAY"=> {:required => [function, symbol, market, interval], :optional => [datatype]},  
            "DIGITAL_CURRENCY_DAILY"=> {:required => [function, symbol, market], :optional => [datatype]},
            "DIGITAL_CURRENCY_WEEKLY"=> {:required => [function, symbol, market], :optional => [datatype]},
            "DIGITAL_CURRENCY_MONTHLY"=> {:required => [function, symbol, market], :optional => [datatype]}
      }

      parameters = @stock_market_parameters.merge(@forex_parameters).merge(@crypto_parameters)

      required_parameters = parameters[function][:required]
      optional_parameters = parameters[function][:optional]

      arr_err = []
      arr_valid = []
      self.each_pair do |parameter, value|
        arr_err << "#{parameter} is not set" if !value && (required_parameters.include? value) #need to fix name choices soon
        arr_err << "#{parameter} should not be set for #{function}" unless (required_parameters+optional_parameters).include?(value) || !value
        arr_valid << "#{parameter}=#{value}" if value
      end

      raise ArgumentError, ' ' + arr_err.join("\n\t\t") + "\n" unless arr_err.empty? #fix newline

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
    call = case @function_type[function]
    when :stock_market_function
      CallStruct.new(function: function, symbol: symbol, interval: interval, outputsize:outputsize, datatype: datatype, keywords: keywords)
    when :forex_function      
      CallStruct.new(function: function, from_currency: from_currency, to_currency: to_currency, from_symbol: from_symbol, to_symbol: to_symbol, interval: interval, outputsize: outputsize, datatype: datatype)
    when :crypto_function
      CallStruct.new(function: function, symbol: symbol, market: market, datatype: datatype)  
    else 
      raise NameError, "Invalid function: #{function}"
    end
    get_json call
  end

  def print_directly(function:, from_currency: false, to_currency: false, from_symbol: false, to_symbol: false, symbol: false, market: false, interval: false, outputsize: false, datatype: false, keywords: false)
    call = case @function_type[function]
    when :stock_market_function
      CallStruct.new(function: function, symbol: symbol, interval: interval, outputsize:outputsize, datatype: datatype, keywords: keywords)
    when :forex_function      
      CallStruct.new(function: function, from_currency: from_currency, to_currency: to_currency, from_symbol: from_symbol, to_symbol: to_symbol, interval: interval, outputsize: outputsize, datatype: datatype)
    when :crypto_function
      CallStruct.new(function: function, symbol: symbol, market: market, datatype: datatype)  
    else 
      raise NameError, "Invalid function: #{function}"
    end
    print_json get_json(call)
  end
end
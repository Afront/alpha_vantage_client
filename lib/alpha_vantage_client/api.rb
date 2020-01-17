require 'Faraday'
require 'JSON'

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
        "CURRENCY_EXCHANGE_RATE"=> :forex_function,
        "FX_INTRADAY"=> :forex_function,
        "FX_DAILY"=> :forex_function,
        "FX_WEEKLY"=> :forex_function,
        "FX_MONTHLY"=> :forex_function,     
  }

  CallStruct = Struct.new(:function, :from_currency, :to_currency, :from_symbol, :to_symbol, :symbol, :interval, :outputsize, :datatype, :keywords) do
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
      parameters = @stock_market_parameters.merge(@forex_parameters)

      required_parameters = parameters[function][:required]
      optional_parameters = parameters[function][:optional]

      arr_err = []
      arr_valid = []
      self.each_pair do |parameter, value|
        arr_err << "#{parameter} is not set" if !value && (required_parameters.include? value) #need to fix name choices soon
        arr_err << "#{parameter} should not be set for #{function}" unless (required_parameters+optional_parameters).include?(value) || !value
        arr_valid << "#{parameter}=#{value}" if value
        break unless arr_err.empty?
      end

      raise ArgumentError, arr_err.join('\n') unless arr_err.empty? #fix newline

      'https://www.alphavantage.co/query?' + arr_valid.join('&') + '&apikey=' + API_KEY
    end
  end

  module_function 

  def get_json call_struct
    json_result = Faraday.get call_struct.get_url
    JSON.parse json_result.body
  end

  def print_json json
  end

  def test(function:, from_currency: false, to_currency: false, from_symbol: false, to_symbol: false, symbol: false, interval: false, outputsize: false, datatype: false, keywords: false)
    call = case @function_type[function]
    when :stock_market_function
      CallStruct.new(function, symbol, interval, outputsize, datatype, keywords)
    when :forex_function      
      CallStruct.new(function, from_currency, to_currency, from_symbol, to_symbol, interval, outputsize, datatype)
    else 
      raise NameError, 'Invalid function: #{function}'
    end
    print_json(get_json(call))
  end
end
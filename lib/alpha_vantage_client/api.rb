require 'Faraday'
require 'JSON'

module API
  raise IOError, 'ALPHA_VANTAGE_API_KEY is not set as an environmental variable' if ENV['ALPHA_VANTAGE_API_KEY'].nil?
  API_KEY = ENV['ALPHA_VANTAGE_API_KEY'].to_s
  CallStruct = Struct.new(:function, :from_currency, :to_currency, :from_symbol, :to_symbol, :symbol, :interval, :outputsize, :datatype, :keywords) do
    def get_url #previously validate_data, get_valid_arr, generate_url
      parameters = {
        #stock market functions
        "TIME_SERIES_INTRADAY"=> {:required => [function, symbol, interval], :optional => [outputsize, datatype]}, 
        "TIME_SERIES_DAILY"=> {:required => [function, symbol], :optional => [outputsize, datatype]},  
        "TIME_SERIES_DAILY_ADJUSTED"=> {:required => [function, symbol], :optional => [outputsize, datatype]},
        "TIME_SERIES_WEEKLY"=> {:required => [function, symbol], :optional => [datatype]},
        "TIME_SERIES_WEEKLY_ADJUSTED"=> {:required => [function, symbol], :optional => [datatype]},
        "TIME_SERIES_MONTHLY"=> {:required => [function, symbol], :optional => [datatype]},
        "TIME_SERIES_MONTHLY_ADJUSTED"=> {:required => [function, symbol], :optional => [datatype]},
        "QUOTE_ENDPOINT"=> {:required => [function, symbol], :optional => [datatype]},
        "SEARCH_ENDPOINT"=> {:required => [function, keywords], :optional => [datatype]},

        #forex functions
        "CURRENCY_EXCHANGE_RATE"=> {:required => [function, from_currency, to_currency], :optional => []}, 
        "FX_INTRADAY"=> {:required => [function, from_symbol, to_symbol, interval], :optional => [outputsize, datatype]},  
        "FX_DAILY"=> {:required => [function, from_symbol, to_symbol], :optional => [outputsize, datatype]},
        "FX_WEEKLY"=> {:required => [function, from_symbol, to_symbol], :optional => [datatype]},
        "FX_MONTHLY"=> {:required => [function, from_symbol, to_symbol], :optional => [datatype]},
        }

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

  def test(function:, symbol: false, interval: false, outputsize: false, datatype: false, keywords: false)
    call = CallStruct.new(function, symbol, interval, outputsize, datatype, keywords)
    print_json(get_json(call))
  end
end
require 'net/http'

module Rates
  # class for fletching rates values from remote server
  class ValuesFetcher
    def initialize(rates)
      @rates = rates
    end

    # sample request
    # https://free.currencyconverterapi.com/api/v6/convert?q=USD_RUB,EUR_RUB&compact=ultra
    #
    # sample response
    # {
    #   "USD_RUB": 66.27403,
    #   "EUR_RUB": 75.37776
    # }
    def call
      uri = URI(url)
      response = Net::HTTP.get(uri)

      JSON.parse(response)
    end

    private

    def url
      # TODO: put to .env file
      "https://free.currencyconverterapi.com/api/v6/convert?q=#{currencies_param}&compact=ultra"
    end

    def currencies_param
      @rates.map(&:to_param).join(',')
    end
  end
end

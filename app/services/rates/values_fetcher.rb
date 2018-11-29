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
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      JSON.parse(response.body)
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

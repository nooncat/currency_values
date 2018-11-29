module Rates
  # class for updating rates values
  class ValuesUpdater
    def initialize(data)
      @data = data
    end

    def call
      @data.each do |key, value|
        rate = ::Rate.find(key)
        rate.update(value: value)
      end
    end
  end
end

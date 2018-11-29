module Rates
  class UpdateValuesWorker < BaseWorker
    def perform(rates_ids)
      return unless rates_ids

      rates = Rate.where(id: rates_ids)
      received_data = Rates::ValuesFetcher.new(rates).call

      Rates::ValuesUpdater.new(received_data).call
    end
  end
end

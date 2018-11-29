namespace :rates do
  desc 'Fetch rates values from remote server'
  task update_values: [:environment] do
    rates = ::Rate.all
    received_data = Rates::ValuesFetcher.new(rates).call
    ap received_data
    Rates::ValuesUpdater.new(received_data).call
  end
end

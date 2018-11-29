namespace :rates do
  desc 'Fetch rates values from remote server'
  task update_values: [:environment] do
    Rates::UpdateValuesWorker.perform_async(Rate.ids)
  end
end

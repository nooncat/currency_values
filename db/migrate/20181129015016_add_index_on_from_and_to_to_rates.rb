class AddIndexOnFromAndToToRates < ActiveRecord::Migration[5.2]
  def change
    add_index :rates, [:from, :to], unique: true
  end
end

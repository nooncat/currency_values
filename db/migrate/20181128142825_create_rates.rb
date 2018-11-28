class CreateRates < ActiveRecord::Migration[5.2]
  def change
    create_table :rates do |t|
      t.string :from, null: false
      t.string :to, null: false
      t.decimal :value, null: false, precision: 16, scale: 6
      t.decimal :manual_value
      t.timestamp :manual_value_till

      t.timestamps null: false
    end
  end
end

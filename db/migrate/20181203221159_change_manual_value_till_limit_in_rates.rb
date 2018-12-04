class ChangeManualValueTillLimitInRates < ActiveRecord::Migration[5.2]
  def up
    change_column :rates, :manual_value_till, :datetime, limit: 0
  end

  def down
    change_column :rates, :manual_value_till, :datetime
  end
end

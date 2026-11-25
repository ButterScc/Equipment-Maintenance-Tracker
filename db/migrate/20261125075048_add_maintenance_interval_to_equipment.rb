class AddMaintenanceIntervalToEquipment < ActiveRecord::Migration[8.1]
  def change
    add_column :equipment, :maintenance_interval_days, :integer
  end
end

class AddNextMaintenanceManualToEquipment < ActiveRecord::Migration[8.1]
  def change
  add_column :equipment, :next_maintenance_manual, :boolean, default: false
end
end

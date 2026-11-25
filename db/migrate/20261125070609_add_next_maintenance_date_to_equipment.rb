class AddNextMaintenanceDateToEquipment < ActiveRecord::Migration[8.1]
  def change
    add_column :equipment, :next_maintenance_date, :date
  end
end
class AddNextMaintenanceDateToMaintenances < ActiveRecord::Migration[8.1]
  def change
    add_column :maintenances, :next_maintenance_date, :date
  end
end

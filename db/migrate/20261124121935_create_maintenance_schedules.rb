class CreateMaintenanceSchedules < ActiveRecord::Migration[8.1]
  def change
    create_table :maintenance_schedules do |t|
      t.references :equipment, null: false, foreign_key: true
      t.string :title
      t.string :maintenance_type
      t.date :scheduled_date
      t.string :status
      t.text :notes

      t.timestamps
    end
  end
end

class CreateMaintenanceRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :maintenance_records do |t|
      t.references :equipment, null: false, foreign_key: true
      t.date :maintenance_date
      t.string :maintenance_type
      t.text :description
      t.string :technician
      t.decimal :cost
      t.date :next_due_date

      t.timestamps
    end
  end
end

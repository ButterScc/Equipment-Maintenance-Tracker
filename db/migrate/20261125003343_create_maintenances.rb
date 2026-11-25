class CreateMaintenances < ActiveRecord::Migration[8.1]
  def change
    create_table :maintenances do |t|
      t.references :equipment, null: false, foreign_key: true
      t.date :maintenance_date
      t.string :maintenance_type
      t.string :technician
      t.text :description

      t.timestamps
    end
  end
end

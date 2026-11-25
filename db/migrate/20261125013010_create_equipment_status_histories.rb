class CreateEquipmentStatusHistories < ActiveRecord::Migration[8.1]
  def change
    create_table :equipment_status_histories do |t|
      t.references :equipment, null: false, foreign_key: true
      t.string :previous_status
      t.string :new_status

      t.timestamps
    end
  end
end

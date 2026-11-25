class CreateEquipment < ActiveRecord::Migration[8.1]
  def change
    create_table :equipment do |t|
      t.string :name
      t.string :code
      t.string :category
      t.string :location
      t.string :status
      t.string :manufacturer
      t.string :model
      t.string :serial_number

      t.timestamps
    end
  end
end

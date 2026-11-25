class AddPriorityToEquipments < ActiveRecord::Migration[8.1]
  def change
    add_column :equipment, :priority, :string
  end
end
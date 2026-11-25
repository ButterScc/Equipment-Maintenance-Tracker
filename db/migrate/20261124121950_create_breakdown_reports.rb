class CreateBreakdownReports < ActiveRecord::Migration[8.1]
  def change
    create_table :breakdown_reports do |t|
      t.references :equipment, null: false, foreign_key: true
      t.datetime :reported_at
      t.string :severity
      t.text :description
      t.string :status
      t.text :resolution

      t.timestamps
    end
  end
end

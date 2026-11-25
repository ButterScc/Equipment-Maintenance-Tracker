class Maintenance < ApplicationRecord
  belongs_to :equipment

  validates :maintenance_date, presence: true
  validates :maintenance_type, presence: true
  validates :technician, presence: true

  def update_equipment_schedule
    latest_maintenance = equipment.maintenances
                                  .order(maintenance_date: :desc, created_at: :desc)
                                  .first

    if latest_maintenance.nil?
      equipment.update!(
        next_maintenance_date: nil,
        next_maintenance_manual: false
      )
      return
    end

    if latest_maintenance.next_maintenance_date.present?
      equipment.update!(
        next_maintenance_date: latest_maintenance.next_maintenance_date,
        next_maintenance_manual: true
      )
    elsif equipment.maintenance_interval_days.present?
      next_date = latest_maintenance.maintenance_date +
                  equipment.maintenance_interval_days.days

      equipment.update!(
        next_maintenance_date: next_date,
        next_maintenance_manual: false
      )
    else
      equipment.update!(
        next_maintenance_date: nil,
        next_maintenance_manual: false
      )
    end
  end
end

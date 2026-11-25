class Equipment < ApplicationRecord
  has_many :maintenance_schedules, dependent: :destroy
  has_many :maintenance_records, dependent: :destroy
  has_many :breakdown_reports, dependent: :destroy
  has_many :maintenances, dependent: :destroy
  has_many :equipment_status_histories, dependent: :destroy

  before_validation :set_priority

  after_update :record_status_change, if: :saved_change_to_status?
  after_update :update_automatic_maintenance_date,
               if: :saved_change_to_maintenance_interval_days?

  validates :name, presence: { message: "tidak boleh kosong" }
  validates :code,
            presence: { message: "tidak boleh kosong" },
            uniqueness: { message: "sudah digunakan, gunakan kode lain" }
  validates :status, presence: { message: "harus dipilih" }

  private

  def update_automatic_maintenance_date
    return if next_maintenance_manual?

    latest_maintenance = maintenances
      .order(maintenance_date: :desc, created_at: :desc)
      .first

    return unless latest_maintenance

    if maintenance_interval_days.present?
      new_date = latest_maintenance.maintenance_date +
                 maintenance_interval_days.days
    else
      new_date = nil
    end

    update_column(:next_maintenance_date, new_date)
  end

  def set_priority
    self.priority = case status.to_s.downcase
                    when "broken"
                      "High"
                    when "maintenance"
                      "Medium"
                    when "active"
                      "Low"
                    end
  end

  def record_status_change
    previous_status, new_status = saved_change_to_status

    equipment_status_histories.create!(
      previous_status: previous_status,
      new_status: new_status
    )
  end
end

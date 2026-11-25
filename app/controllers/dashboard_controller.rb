class DashboardController < ApplicationController
  def index
    @overdue_schedules = Equipment
      .where("next_maintenance_date < ?", Date.current)
      .order(:next_maintenance_date)

    @due_soon_schedules = Equipment
      .where(next_maintenance_date: Date.current..7.days.from_now.to_date)
      .order(:next_maintenance_date)

    @overdue_schedule_count = @overdue_schedules.count
    @due_soon_schedule_count = @due_soon_schedules.count
  end
end

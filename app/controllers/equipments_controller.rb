
class EquipmentsController < ApplicationController
  before_action :set_equipment, only: [:show, :edit, :update, :destroy]

  def index
    @equipments = Equipment.all

    # Most Maintained Equipment
    equipment_table = Equipment.table_name

    @most_maintained_equipment = Equipment
      .left_joins(:maintenances)
      .select("#{equipment_table}.*, COUNT(maintenances.id) AS maintenance_count")
      .group("#{equipment_table}.id")
      .order("maintenance_count DESC")
      .first

    # Equipment Pernah Maintenance
    @equipment_ever_maintained = Equipment
      .joins(:maintenances)
      .distinct
      .count

    # Search
    if params[:search].present?
      @equipments = @equipments.where(
        "name LIKE :q OR code LIKE :q OR location LIKE :q",
        q: "%#{params[:search]}%"
      )
    end

    # Filter Status
    if params[:status].present?
      @equipments = @equipments.where(status: params[:status])
    end

    # Filter Priority
    if params[:priority].present?
      @equipments = @equipments.where(priority: params[:priority])
    end

    # Filter Periode Grafik
    @chart_period = params[:period].presence_in(%w[6 12 24]) || "12"

    start_date = (@chart_period.to_i - 1).months.ago.beginning_of_month.to_date
    end_date = Date.current

    monthly_maintenances = Maintenance
      .where(maintenance_date: start_date..end_date)
      .group_by { |maintenance| maintenance.maintenance_date.beginning_of_month }

    months = @chart_period.to_i

    @maintenance_chart_labels = (0...months).map do |i|
      (start_date + i.months).strftime("%b %Y")
    end

    @maintenance_chart_data = (0...months).map do |i|
      month = start_date + i.months
      monthly_maintenances.fetch(month.beginning_of_month, []).count
    end

    @overdue_schedule_count = Equipment.where(
      "next_maintenance_date < ?", Date.current
    ).count

    @due_soon_count = Equipment.where(
      next_maintenance_date: Date.current..7.days.from_now.to_date
    ).count

    @scheduled_count = Equipment.where(
      "next_maintenance_date > ?", 7.days.from_now.to_date
    ).count

    @upcoming_scheduled_equipments = Equipment
    .where.not(next_maintenance_date: nil)
    .where("next_maintenance_date <= ?", 7.days.from_now.to_date)
    .order(:next_maintenance_date)

  
    
# Dashboard Statistics
@total_equipment = Equipment.count
@active_equipment = Equipment.where("LOWER(status) = ?", "active").count
@maintenance_equipment = Equipment.where("LOWER(status) = ?", "maintenance").count
@broken_equipment = Equipment.where("LOWER(status) = ?", "broken").count

# Equipment Status Chart
@status_chart_labels = ["Active", "Maintenance", "Broken"]

@status_chart_data = [
  @active_equipment,
  @maintenance_equipment,
  @broken_equipment
]

# Maintenance Performance Analytics
@maintenance_this_month = Maintenance
  .where(maintenance_date: Date.current.beginning_of_month..Date.current.end_of_month)
  .count

@maintenance_this_year = Maintenance
  .where(maintenance_date: Date.current.beginning_of_year..Date.current.end_of_year)
  .count

@average_maintenance = (
  @maintenance_this_year.to_f / Date.current.month
).round(1)

@top_technician = Maintenance
  .where(maintenance_date: Date.current.beginning_of_year..Date.current.end_of_year)
  .group(:technician)
  .order(Arel.sql("COUNT(*) DESC"))
  .count
  .first

# Maintenance Overdue Alert
@overdue_equipments = Equipment
  .left_joins(:maintenances)
  .select(
    "equipment.*, MAX(maintenances.maintenance_date) AS last_maintenance_date"
  )
  .group("equipment.id")
  .having(
    "MAX(maintenances.maintenance_date) IS NULL OR MAX(maintenances.maintenance_date) < ?",
    90.days.ago.to_date
  )
  .to_a



    # Pagination
    @per_page = 10
    @current_page = [params[:page].to_i, 1].max

    @total_pages = (@equipments.count.to_f / @per_page).ceil
    @total_pages = 1 if @total_pages < 1

    @current_page = [@current_page, @total_pages].min

    @equipments = @equipments
      .order(id: :desc)
      .limit(@per_page)
      .offset((@current_page - 1) * @per_page)
  end

  def show
    @maintenances = @equipment.maintenances
      .order(maintenance_date: :desc)
  end

  def new
    @equipment = Equipment.new
  end

  def create
    @equipment = Equipment.new(equipment_params)

    if @equipment.save
      redirect_to equipments_path, notice: "Equipment berhasil ditambahkan."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @equipment.update(equipment_params)
      redirect_to equipments_path, notice: "Equipment berhasil diperbarui."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @equipment.destroy
    redirect_to equipments_path, notice: "Equipment berhasil dihapus."
  end

  def monitoring
    @equipments = Equipment.includes(:maintenances).all
  end

  
def calendar
  @month = if params[:month].present?
    Date.strptime("#{params[:month]}-01", "%Y-%m-%d")
  else
    Date.current
  end

  start_date = @month.beginning_of_month
  end_date = @month.end_of_month

  @calendar_equipments = Equipment
    .where(next_maintenance_date: start_date..end_date)
    .order(:next_maintenance_date)

  @calendar_days = (start_date.beginning_of_week(:monday)..end_date.end_of_month)
    .to_a
    .each_slice(7)
    .to_a
end


  private

  def set_equipment
    @equipment = Equipment.find(params[:id])
  end

  def equipment_params
  params.require(:equipment).permit(
    :name,
    :code,
    :category,
    :location,
    :status,
    :manufacturer,
    :model,
    :serial_number,
    :next_maintenance_date,
    :maintenance_interval_days
  )
end
end


class MaintenancesController < ApplicationController
  before_action :set_maintenance, only: [:edit, :update, :destroy]

  def index
    @maintenances = Maintenance.includes(:equipment)
                               .order(maintenance_date: :desc)

    @per_page = 10
    @current_page = [params[:page].to_i, 1].max

    @total_pages = (@maintenances.count.to_f / @per_page).ceil
    @total_pages = 1 if @total_pages < 1

    @current_page = [@current_page, @total_pages].min

    @maintenances = @maintenances
                      .limit(@per_page)
                      .offset((@current_page - 1) * @per_page)
  end

  def new
    @maintenance = Maintenance.new
  end

 def create
  @maintenance = Maintenance.new(maintenance_params)

  if @maintenance.save
    @maintenance.update_equipment_schedule

    redirect_to maintenances_path, notice: "Maintenance berhasil ditambahkan."
  else
    render :new, status: :unprocessable_entity
  end
end

  def edit
  end

  def update
  previous_equipment = @maintenance.equipment

  if @maintenance.update(maintenance_params)
    refresh_equipment_schedule(previous_equipment)

    if @maintenance.equipment_id != previous_equipment.id
      @maintenance.update_equipment_schedule
    end

    redirect_to maintenances_path, notice: "Maintenance berhasil diperbarui."
  else
    render :edit, status: :unprocessable_entity
  end
end

 def destroy
  equipment = @maintenance.equipment

  if @maintenance.destroy
    refresh_equipment_schedule(equipment)

    redirect_to maintenances_path, notice: "Maintenance berhasil dihapus."
  else
    redirect_to maintenances_path, alert: "Maintenance gagal dihapus."
  end
end

  def report
    @maintenances = Maintenance.includes(:equipment)
                               .order(maintenance_date: :desc)

    if params[:start_date].present?
      @maintenances = @maintenances.where(
        "maintenance_date >= ?", params[:start_date]
      )
    end

    if params[:end_date].present?
      @maintenances = @maintenances.where(
        "maintenance_date <= ?", params[:end_date]
      )
    end

    @total_maintenance = @maintenances.count
  end

  def export_pdf
    @maintenances = Maintenance.includes(:equipment)
                               .order(maintenance_date: :desc)

    if params[:start_date].present?
      @maintenances = @maintenances.where(
        "maintenance_date >= ?", params[:start_date]
      )
    end

    if params[:end_date].present?
      @maintenances = @maintenances.where(
        "maintenance_date <= ?", params[:end_date]
      )
    end

    require "prawn"

    pdf = Prawn::Document.new

    pdf.text "MAINTENANCE REPORT", size: 20, style: :bold, align: :center
    pdf.move_down 20

    pdf.text "Tanggal Cetak: #{Date.today}"
    pdf.text "Total Maintenance: #{@maintenances.count}"

    pdf.move_down 20

    @maintenances.each_with_index do |maintenance, index|
      pdf.text "#{index + 1}. #{maintenance.equipment.name}", style: :bold
      pdf.text "Tanggal: #{maintenance.maintenance_date}"
      pdf.text "Jenis: #{maintenance.maintenance_type}"
      pdf.text "Teknisi: #{maintenance.technician}"
      pdf.text "Deskripsi: #{maintenance.description.presence || '-'}"
      pdf.move_down 10
    end

    send_data pdf.render,
              filename: "maintenance-report.pdf",
              type: "application/pdf",
              disposition: "attachment"
  end

 

  private

  def refresh_equipment_schedule(equipment)
  latest_maintenance = equipment.maintenances
                                .order(maintenance_date: :desc, created_at: :desc)
                                .first

  if latest_maintenance
    latest_maintenance.update_equipment_schedule
  else
    equipment.update!(
      next_maintenance_date: nil,
      next_maintenance_manual: false
    )
  end
end

  def set_maintenance
    @maintenance = Maintenance.find(params[:id])
  end

  def maintenance_params
  params.require(:maintenance).permit(
    :equipment_id,
    :maintenance_date,
    :maintenance_type,
    :technician,
    :description,
    :next_maintenance_date
  )
end
end

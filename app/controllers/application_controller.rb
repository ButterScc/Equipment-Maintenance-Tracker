class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :set_sidebar_notifications

  private

  def set_sidebar_notifications
    @sidebar_overdue_count = Equipment.where(
    "next_maintenance_date < ?", Date.current
  ).count
    @sidebar_due_soon_count = Equipment.where(
    next_maintenance_date: Date.current..7.days.from_now.to_date
  ).count
  end
end

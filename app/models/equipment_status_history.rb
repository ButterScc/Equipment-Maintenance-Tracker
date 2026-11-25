class EquipmentStatusHistory < ApplicationRecord
  belongs_to :equipment

  validates :previous_status, presence: true
  validates :new_status, presence: true
end
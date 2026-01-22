class Venue < ApplicationRecord
  has_many :live_schedules, dependent: :nullify
  has_many :live_records, -> { attended }, class_name: "LiveSchedule", dependent: :nullify
  belongs_to :user
  validates :name, presence: true
end

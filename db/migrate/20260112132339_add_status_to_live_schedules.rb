class AddStatusToLiveSchedules < ActiveRecord::Migration[6.1]
  def change
    add_column :live_schedules, :status, :integer, null: false, default: 0
    add_index  :live_schedules, :status
  end
end

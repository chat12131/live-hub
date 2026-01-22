class RemoveAreaFromLiveSchedules < ActiveRecord::Migration[6.1]
  def change
    remove_column :live_schedules, :area, :string
  end
end

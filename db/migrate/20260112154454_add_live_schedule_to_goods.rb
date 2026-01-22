class AddLiveScheduleToGoods < ActiveRecord::Migration[6.1]
  def change
    unless column_exists?(:goods, :live_schedule_id)
      add_reference :goods, :live_schedule, null: true, foreign_key: true
    end

    add_index :goods, :live_schedule_id unless index_exists?(:goods, :live_schedule_id)
    add_foreign_key :goods, :live_schedules unless foreign_key_exists?(:goods, :live_schedules)
  end
end
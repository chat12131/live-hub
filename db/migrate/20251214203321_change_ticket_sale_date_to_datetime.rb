class ChangeTicketSaleDateToDatetime < ActiveRecord::Migration[6.1]
  def change
    change_column :live_schedules, :ticket_sale_date, :datetime
  end
end

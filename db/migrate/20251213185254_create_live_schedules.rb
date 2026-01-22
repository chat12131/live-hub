class CreateLiveSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :live_schedules do |t|
      t.string :name
      t.references :artist, null: false, foreign_key: true
      t.date :date
      t.time :open_time
      t.time :start_time
      t.references :venue, null: false, foreign_key: true
      t.string :area
      t.integer :ticket_status
      t.integer :ticket_price
      t.integer :drink_price
      t.date :ticket_sale_date
      t.string :timetable
      t.string :announcement_image
      t.text :memo
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

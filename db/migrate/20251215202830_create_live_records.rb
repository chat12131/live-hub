class CreateLiveRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :live_records do |t|
      t.string :name
      t.references :artist, foreign_key: true
      t.date :date
      t.time :start_time
      t.references :venue, null: false, foreign_key: true
      t.integer :ticket_price
      t.integer :drink_price
      t.string :timetable
      t.string :announcement_image
      t.text :memo
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

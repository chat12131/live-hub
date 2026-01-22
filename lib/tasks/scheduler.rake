namespace :scheduler do
  desc "Migrate live schedules to live records"
  task migrate_live_schedules: :environment do
    LiveSchedule.where(date: Date.current).find_each do |schedule|
      LiveRecord.create!(
        name: schedule.name,
        artist_id: schedule.artist_id,
        date: schedule.date,
        start_time: schedule.start_time,
        venue_id: schedule.venue_id,
        ticket_price: schedule.ticket_price,
        drink_price: schedule.drink_price,
        memo: schedule.memo,
        user_id: schedule.user_id
      )
    end
  end

  desc "Delete future live schedules from tomorrow onwards"
  task delete_past_schedules: :environment do
    LiveSchedule.where('date < ?', Date.current).destroy_all
  end
end

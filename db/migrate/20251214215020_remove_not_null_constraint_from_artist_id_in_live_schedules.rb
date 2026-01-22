class RemoveNotNullConstraintFromArtistIdInLiveSchedules < ActiveRecord::Migration[6.1]
  def change
    change_column_null :live_schedules, :artist_id, true
  end
end

class RemoveLiveRecordIdFromGoods < ActiveRecord::Migration[6.1]
  def change
    remove_column :goods, :live_record_id, :bigint
  end
end

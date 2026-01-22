class AddDateToGoods < ActiveRecord::Migration[6.1]
  def change
    add_column :goods, :date, :date
  end
end

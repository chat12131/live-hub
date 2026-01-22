class CreateGoods < ActiveRecord::Migration[6.1]
  def change
    create_table :goods do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name
      t.integer :quantity
      t.integer :price
      t.references :user, null: false, foreign_key: true
      t.references :live_record, foreign_key: true
      t.references :artist, foreign_key: true
      t.references :member, foreign_key: true

      t.timestamps
    end
  end
end

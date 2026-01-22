class CreateArtists < ActiveRecord::Migration[6.1]
  def change
    create_table :artists do |t|
      t.string :name, null: false
      t.string :nickname
      t.string :image
      t.string :genre
      t.references :user, foreign_key: true
      t.text :memo
      t.boolean :nickname_mode, default: false
      t.boolean :favorited, default: false
      t.date :founding_date
      t.date :first_show_date
      t.timestamps
    end

    add_index :artists, :name
    add_index :artists, :nickname
  end
end

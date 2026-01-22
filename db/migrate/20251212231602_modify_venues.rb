class ModifyVenues < ActiveRecord::Migration[6.1]
  def change
    remove_column :venues, :address

    add_column :venues, :latitude, :float
    add_column :venues, :longitude, :float

    add_column :venues, :area, :string
  end
end

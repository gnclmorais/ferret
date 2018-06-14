class AddLatLngToPlaces < ActiveRecord::Migration[5.1]
  def change
    add_column :places, :lat, :string
    add_column :places, :lng, :string
  end
end

class CreatePlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :places do |t|
      t.string :google_place_id, null: false
      t.string :name,            null: false
      t.text :address,           null: false
      t.text :description

      t.timestamps
    end
  end
end

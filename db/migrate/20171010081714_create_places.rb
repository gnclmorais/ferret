class CreatePlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :places do |t|
      t.string :google_place_id
      t.text :address,     null: false
      t.string :name,      null: false
      t.text :description, null: false

      t.timestamps
    end
  end
end

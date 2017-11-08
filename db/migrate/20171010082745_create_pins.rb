class CreatePins < ActiveRecord::Migration[5.1]
  def change
    create_table :pins do |t|
      t.references :place, null: false, foreign_key: true
      t.references :map,   null: false, foreign_key: true

      t.timestamps
    end
  end
end

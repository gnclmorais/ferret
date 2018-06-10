class AddNameToPins < ActiveRecord::Migration[5.1]
  def up
    add_column :pins, :name, :string, null: true

    Pin.all.each do |pin|
      pin.name = pin.place.name
      pin.save
    end

    change_column_null :pins, :name, false
  end

  def down
    remove_colum :pins, :name
  end
end

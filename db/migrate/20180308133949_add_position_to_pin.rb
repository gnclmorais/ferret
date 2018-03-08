class AddPositionToPin < ActiveRecord::Migration[5.1]
  def change
    add_column :pins, :position, :integer

    Pin.order(:updated_at).each.with_index(1) do |pin, index|
      pin.update_column :position, index
    end

    change_column :pins, :position, :integer, null: false
  end
end

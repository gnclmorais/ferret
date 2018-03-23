class AddIndexToTaggedPins < ActiveRecord::Migration[5.1]
  def change
    add_index :tagged_pins, %i[tag_id pin_id], unique: true, name: 'tag_to_pin'
  end
end

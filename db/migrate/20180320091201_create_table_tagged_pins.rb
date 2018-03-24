class CreateTableTaggedPins < ActiveRecord::Migration[5.1]
  def change
    create_table :tagged_pins do |t|
      t.integer "tag_id"
      t.integer "pin_id"
      t.index :tag_id
    end
  end
end

class CreateJoinTableTaggedPins < ActiveRecord::Migration[5.1]
  def change
    create_join_table :tags, :pins, table_name: :tagged_pins do |t|
      t.integer "tag_id"
      t.integer "pin_id"
      t.index :tag_id
    end
  end
end

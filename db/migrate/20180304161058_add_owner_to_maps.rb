class AddOwnerToMaps < ActiveRecord::Migration[5.1]
  def change
    add_reference   :maps, :owner, null: false
    add_foreign_key :maps, :users, column: :owner_id, on_delete: :cascade
  end
end

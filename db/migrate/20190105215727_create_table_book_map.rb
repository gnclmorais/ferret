class CreateTableBookMap < ActiveRecord::Migration[5.2]
  def change
    create_table :book_maps do |t|
      t.integer "book_id"
      t.integer "map_id"
    end
  end
end

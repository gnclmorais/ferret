class CreateJoinTableTaggedPin < ActiveRecord::Migration[5.1]
  def change
    create_join_table :tags, :pins do |t|
      t.index [:tag_id, :pin_id]
    end
  end
end

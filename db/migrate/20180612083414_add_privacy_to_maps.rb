class AddPrivacyToMaps < ActiveRecord::Migration[5.1]
  def change
    add_column :maps, :private, :boolean, default: false, null: false
  end
end

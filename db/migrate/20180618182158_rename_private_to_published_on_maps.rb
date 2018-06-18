class RenamePrivateToPublishedOnMaps < ActiveRecord::Migration[5.1]
  def change
    rename_column :maps, :private, :published
  end
end

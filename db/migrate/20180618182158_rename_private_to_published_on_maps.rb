class RenamePrivateToPublishedOnMaps < ActiveRecord::Migration[5.1]
  def up
    rename_column :maps, :private, :published

    Map.update_all(published: true)
  end

  def down
    rename_column :maps, :published, :private

    Map.update_all(private: false)
  end
end

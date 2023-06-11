class AddSoundcloudPlaylistSupportToKatha < ActiveRecord::Migration[7.0]
  def change
    add_column :kathas, :is_playlist, :boolean, :default => false
  end
end

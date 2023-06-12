# frozen_string_literal: true

json.key_format! :camelize => :lower

# :kathas => { :id, :gianiId, :title, :publicUrl, :isPlaylist, :soundcloudUrl, :year }
json.kathas do
  json.array!(@kathas, :id, :giani_id, :title, :public_url, :is_playlist, :soundcloud_url, :year)
end

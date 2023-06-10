# frozen_string_literal: true

json.key_format! :camelize => :lower

# :kathas => { :id, :gianiId, :title, :publicUrl, :soundcloudUrl, :year }
json.kathas do
  json.array!(@kathas, :id, :giani_id, :title, :public_url, :soundcloud_url, :year)
end

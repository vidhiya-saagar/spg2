# frozen_string_literal: true

# This file contains the list of all Gianis in the system
# Each Giani record should have a unique ID and name
# To add or update a new Giani, add a new entry to the GIANIS array below
GIANIS = [
  { :id => 1, :name => 'Giani Harbhajan Singh Dhudike', :artwork_url => nil },
  { :id => 2, :name => 'Nihang Giani Sher Singh Ambala', :artwork_url => nil },
  { :id => 3, :name => 'Sant Giani Inderjit Singh Raqbewale', :artwork_url => nil },
  { :id => 4, :name => 'Bhai Sukha Singh UK', :artwork_url => nil },
  { :id => 5, :name => 'The Suraj Podcast', :artwork_url => nil },
  { :id => 6,
    :name => 'Baba Jagjit Singh Harkhowal Wale',
    :artwork_url => 'https://farm3.static.flickr.com/2532/4101681517_f5e2e73d23.jpg' }
]

# Create or update Gianis
GIANIS.each do |giani_data|
  giani = Giani.find_or_initialize_by(:id => giani_data[:id])
  giani.name = giani_data[:name]
  giani.artwork_url = giani_data[:artwork_url]
  giani.save!
end

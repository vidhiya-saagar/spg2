# frozen_string_literal: true

##
# == ContentfulTukImporter
#
# This class is similar to the `ContentfulPauriImporter`.
# ⭐ For more detailed documentation, see `ContentfulPauriImporter`
#
# === Differences from `ContentfulPauriImporter`
# This class handles importing `TukFootnote` entries instead of `PauriFootnote` entries from Contentful.
#
# The `TukFootnote` entry in Contentful follows a different naming convention: "Book 16 Chapter 34 Tuk 34.1"
# This corresponds to the first line (`tuk.sequence => 1`) in the 34th stanza (`pauri.number => 34`), of Book 16, chapter 34.
#
# === Temporary Hack
# Due to Contentful's limit of returning only 100 entries per API call, a temporary hack is used in the `entries` method.
# It makes multiple API calls to fetch all entries by incrementing the `:skip` parameter until it has fetched all `tukFootnote` entries.
#
# === Idempotent Import
# Similar to `ContentfulPauriImporter`, the `import_latest_entries` method only imports new entries and is idempotent.
# It fetches the latest entries from Contentful and compares them with the existing entries in the Rails application.
# New entries are created only for those which do not exist in the Rails application, thus avoiding any duplication.
##
class ContentfulTukImporter
  def initialize
    @client = Contentful::Client.new(
      :access_token => ENV.fetch('CMS_ACCESS_TOKEN', nil),
      :space => ENV.fetch('CMS_SPACE_ID', nil),
      :dynamic_entries => :auto,
      :raise_errors => true
    )
  end

  ##
  # Retrieves all `tukFootnote` entries from Contentful, circumventing its 100 entries limit per API call.
  # Be mindful of potential rate limiting with a high number of entries.
  #
  # @returns [Array<Hash>] An array of Hashes each containing `:id` and `:entry_name` of a tukFootnote.
  # @example [{id: "6fy52qIYDK8EyisyaaBe4o", entry_name: "Book 16 Chapter 34 Tuk 34.1"}, {...}, {...}]
  ##
  def entries
    all_entries = []
    limit = 1000
    skip = 0
    total = 1

    while all_entries.size < total
      response = @client.entries(:content_type => 'tukFootnote', :limit => limit, :skip => skip)
      total = response.total
      all_entries += response.items.map { |e| { :id => e.id, :entry_name => e.entry_name } }
      skip += limit
    end

    return all_entries
  end

  # ContentfulTukImporter.new.latest_entries
  def latest_entries
    @entries = self.entries

    # Only import `contentful_entry_id` if it doesn't exist already.
    existing_ids = TukFootnote.pluck(:contentful_entry_id)
    new_entries = @entries.reject { |e| existing_ids.include?(e[:id]) }
    return new_entries
  end

  # ContentfulTukImporter.new.import_latest_entries
  def import_latest_entries
    # new_entries = self.entries
    new_entries = self.latest_entries
    new_entries.each do |e|
      metadata = self.extract_info(e[:entry_name])
      @book = Book.find_by(:sequence => metadata[:book_number])
      @chapter = @book.chapters.find_by(:number => metadata[:chapter_number])
      @pauri = @chapter.pauris.find_by(:number => metadata[:pauri_number])
      @tuk = @pauri.tuks.find_by(:sequence => metadata[:tuk_number])
      if @tuk
        # Use existing `footnote`. If one already exists, overwrite it.
        @tuk_footnote = @tuk.footnote || TukFootnote.new(:tuk => @tuk)
        @tuk_footnote.update(:contentful_entry_id => e[:id])
      else
        Rails.logger.debug { "❌ Error: Tuk with book_number: #{metadata[:book_number]}, chapter_number: #{metadata[:chapter_number]}, pauri_number: #{metadata[:pauri_number]}, tuk_number: #{metadata[:tuk_number]} was not found" }
      end
    rescue ArgumentError => e
      Rails.logger.debug { "❌ Error: #{e.message}" }
    end
  end

  def extract_info(entry_name)
    regex = /book\s*(\d{1,2})\s*chapter\s*(\d{1,2})\s*tuk\s*(\d{1,2})\.(\d{1,2})/i
    match = regex.match(entry_name)

    raise ArgumentError, 'Invalid string format' unless match
    {
      :book_number => match[1].to_i,
      :chapter_number => match[2].to_i,
      :pauri_number => match[3].to_i,
      :tuk_number => match[4].to_i
    }
  end
end

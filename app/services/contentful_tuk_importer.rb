# frozen_string_literal: true

class ContentfulTukImporter
  def initialize
    @client = Contentful::Client.new(
      :access_token => ENV.fetch('CMS_ACCESS_TOKEN', nil),
      :space => ENV.fetch('CMS_SPACE_ID', nil),
      :dynamic_entries => :auto,
      :raise_errors => true
    )
  end

  # Temporary hack to get around Contentful's 100 entry limit.
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

# frozen_string_literal: true

json.chapter do
  # :chapter => {:id, :number, :title, :en_title, :en_short_summary, :en_short_summary, :artwork_url}
  json.call(@chapter, :id, :number, :title, :en_title, :en_short_summary, :en_short_summary, :artwork_url)

  # :book => {:id, :sequence, :title, :en_title, :en_short_summary, :en_synopsis, :artwork_url}
  json.book(@chapter.book, :id, :sequence, :title, :en_title, :en_short_summary, :en_synopsis, :artwork_url)

  # :chhands => {:id, :sequence, :vaak}
  json.chhands @chapter.chhands.order(:sequence => :ASC) do |chhand|
    json.call(chhand, :id, :sequence, :vaak)
    json.name(chhand.chhand_type.name)

    json.pauris chhand.pauris.order(:sequence => :ASC) do |pauri|
      json.call(pauri, :id, :number, :translation)
      json.footnote do
        json.call(pauri.external_pauri, :bhai_vir_singh_footnote, :content, :original_content)
      end

      json.tuks pauri.tuks.order(:sequence => :ASC) do |tuk|
        json.call(tuk, :id, :sequence, :content, :original_content, :translation)
        json.footnote do
          json.call(tuk.footnote, :bhai_vir_singh_footnote, :contentful_entry_id)
        end
      end
    end
  end
end

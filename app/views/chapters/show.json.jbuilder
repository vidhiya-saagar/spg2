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

    # :pauris => {:id, :number, :translation}
    json.pauris chhand.pauris.order(:sequence => :ASC) do |pauri|
      json.call(pauri, :id, :number)
      json.translation do
        if pauri.translation && (pauri.translation.en_translation || pauri.translation.en_translator)
          json.call(pauri.translation, :en_translation, :en_translator)
        else
          json.null!
        end
      end
      json.footnote do
        if pauri.footnote && (pauri.footnote.bhai_vir_singh_footnote || pauri.footnote.contentful_entry_id)
          json.call(pauri.footnote, :bhai_vir_singh_footnote, :contentful_entry_id)
        else
          json.null!
        end
      end

      json.tuks pauri.tuks.order(:sequence => :ASC) do |tuk|
        json.call(tuk, :id, :sequence, :content, :original_content)
        json.translation do
          if tuk.translation && (tuk.translation.en_translation || tuk.translation.en_translator)
            json.call(tuk.translation, :en_translation, :en_translator)
          else
            json.null!
          end
        end
        json.footnote do
          if tuk.footnote && (tuk.footnote.bhai_vir_singh_footnote || tuk.footnote.contentful_entry_id)
            json.call(tuk.footnote, :bhai_vir_singh_footnote, :contentful_entry_id)
          else
            json.null!
          end
        end
      end
    end
  end
end

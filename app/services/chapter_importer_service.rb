# frozen_string_literal: true

class ChapterImporterService
  attr_reader :book, :chapter_number, :pastel, :prompt, :chapter

  def initialize(book, chapter_number)
    @book = book
    @chapter_number = chapter_number
    @pastel = Pastel.new
    @prompt = TTY::Prompt.new
  end

  def call
    ensure_chapter_exists!
    ActiveRecord::Base.transaction do
      each_csv_row do |row|
        process_row(row)
      end
    end
  end

  private

  def each_csv_row(&)
    blob = chapter.csv_rows
    blob.each(&)
  end

  def ensure_chapter_exists!
    @chapter = book.chapters.find_by(:number => chapter_number)
    raise "Chapter not found: #{chapter_number}" unless @chapter
  end

  def process_row(row)
    # `Chapter_Name`
    validate_and_update_chapter_title(row)

    # `__Chapter_Title_EN`
    update_chapter_title_en(row)

    # `__Short_Summary_EN`, `__Long_Summary_EN`
    update_summary(row)

    process_pauri(row)
    process_tuk(row)
    create_tuk_translation(row)
    create_pauri_translation(row)
  end

  def validate_and_update_chapter_title(row)
    title = row['Chapter_Name'].try(:strip)
    return if chapter.title == title

    message = "The name in Book #{book.sequence}, Chapter #{chapter_number} is " +
              pastel.bold('presently') +
              " '#{chapter.title}'. The CSV says '#{title}'."
    prompt.say(message, :color => :yellow)
    answer = prompt.yes?("Do you want to continue and update this `title` to '#{title}'?")
    raise 'Aborted by user' unless answer

    chapter.update(:title => title)
    Rails.logger.debug pastel.green.dim("✓ Chapter #{chapter_number}'s `title` updated to '#{title}'")
  end

  def update_chapter_title_en(row)
    en_title = row['__Chapter_Title_EN'].try(:strip)

    return if chapter.en_title == en_title || en_title.blank?
    chapter.update(:en_title => en_title)
    Rails.logger.debug pastel.on_green("✓ Chapter #{chapter_number}'s `en_title` updated to '#{en_title}'")
  end

  def update_summary(row)
    en_short_summary = row['__Short_Summary_EN'].try(:strip)
    if en_short_summary && chapter.en_short_summary != en_short_summary
      chapter.update(:en_short_summary => en_short_summary)
      Rails.logger.debug pastel.on_green("✓ Chapter #{chapter_number}'s `en_short_summary` updated")
    end

    en_long_summary = row['__Long_Summary_EN'].try(:strip)
    if en_long_summary && chapter.en_long_summary != en_long_summary
      chapter.update(:en_long_summary => en_long_summary)
      Rails.logger.debug pastel.on_green("✓ Chapter #{chapter_number}'s `en_long_summary` updated")
    end
  end

  def process_pauri(row)
    pauri_number = row['Pauri_Number'].to_i
    @pauri = chapter.pauris.find_by(:number => pauri_number)

    raise "Pauri not found: #{pauri_number}" if @pauri.nil?
  end

  def process_tuk(row)
    tuk = row['Tuk'].try(:strip)
    tuk_number = row['Tuk_Number'].to_i
    @tuk = @pauri.tuks.find_by(:sequence => tuk_number)

    raise "Tuk #{tuk_number} not found: #{tuk}" if @tuk.nil?

    return if @tuk.original_content == tuk

    diff = Diffy::Diff.new(@tuk.original_content, tuk, :include_diff_info => true).to_s(:color)
    Rails.logger.debug diff

    choices = [
      "Keep the NEW one from the CSV (update the original) :: #{tuk}",
      pastel.red("Keep the original :: #{@tuk.original_content}")
    ]

    selected_choice = prompt.select('Choose an option:', choices)
    case selected_choice
    when choices[0]
      @tuk.update(:original_content => tuk)
      Rails.logger.debug pastel.green("✓ `Tuk` `original_content` updated to #{tuk} - For #{@pauri.number}.#{tuk_number}")
    when choices[1]
      Rails.logger.debug pastel.red("x Keeping the original `Tuk` `original_content` - For #{@pauri.number}.#{tuk_number}")
    end
  end

  def create_tuk_translation(row)
    tuk_translation_en = row['Tuk_Translation_EN'].try(:strip) || row['Translation_EN'].try(:strip)
    return if tuk_translation_en.blank?

    # If there's a Pauri translation and a Tuk translation, ask what to do
    if @pauri.translation.present?
      choices = [
        'Continue with the `TukTranslation` and KEEP the `PauriTranslation`, too!',
        'Destroy the existing `PauriTranslation`, and continue with only the `TukTranslation`',
        pastel.red('Abort')
      ]
      selected_choice = prompt.select('Choose an option:', choices)

      case selected_choice
      when choices[0]
        upsert_tuk_translation(tuk_translation_en, row['Assigned_Singh'].try(:strip))
      when choices[1]
        upsert_tuk_translation(tuk_translation_en, row['Assigned_Singh'].try(:strip))
        @pauri.translation.destroy
      when choices[2]
        raise 'Aborted by user'
      end
    else
      upsert_tuk_translation(tuk_translation_en, row['Assigned_Singh'].try(:strip))
    end
  end

  def upsert_tuk_translation(translation, translator)
    @tuk_translation = @tuk.translation || TukTranslation.new(:tuk_id => @tuk.id)
    @tuk_translation.update(:en_translation => translation, :en_translator => translator)
    # Rails.logger.debug pastel.green("✓ `TukTranslation` created or updated for Tuk #{translation} - Pauri # #{@pauri.number}")
  end

  def create_pauri_translation(row)
    pauri_translation_en = row['Pauri_Translation_EN'].try(:strip)
    return if pauri_translation_en.blank?

    pauri_translation = @pauri.translation || PauriTranslation.new(:pauri_id => @pauri.id)
    pauri_translation.update(:en_translation => pauri_translation_en, :en_translator => row['Assigned_Singh'].try(:strip))
    # Rails.logger.debug pastel.green("✓ `PauriTranslation` created or updated for Pauri # #{@pauri.number}")
  end
end

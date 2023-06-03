# frozen_string_literal: true

require 'csv'
class Book < ApplicationRecord
  has_many :chapters, :dependent => :destroy

  def last_chapter
    return self.chapters.last
  end

  def last_chhand
    return last_chapter.chhands.last
  end

  def last_pauri
    return last_chhand.pauris.last
  end

  def last_tuk
    return last_pauri.tuks.last
  end

  ##
  # Create (or update) the a specific chapter via CSV
  # HOW IT WORKS:
  # 1. Add your CSV file to `lib/imports/#{book.sequence}/#{chapter_number}.csv`
  # 2. Pass in a `chapter_number: Integer` e.g. `3`
  # 3. Call `@book.import_chapter(3)`.
  # EXAMPLE:
  #   @book = Book.find_by(:sequence => 1)
  #   @book.import_chapter(3)
  #   This will search for a CSV file at `lib/imports/1/3.csv` (or raise error)
  # The CSV file should have the following columns:
  # - Chapter_Number: Integer
  # - Chapter_Name: String
  # - Chhand_Type: String
  # - Tuk: String
  # - Pauri_Number: Integer
  # - Pauri_Translation_EN: String | NULL
  # - Tuk_Translation_EN: String | NULL
  # - Footnotes: String | NULL
  # - Extended_Ref: String | NULL
  # - Assigned_Singh: String | NULL
  # - Extended_Meaning: String | NULL
  ##
  def import_chapter(chapter_number)
    prompt = TTY::Prompt.new
    pastel = Pastel.new

    Rails.logger.debug 'HELLO'
    @chapter = self.chapters.find_by(:number => chapter_number)
    raise "Chapter not found: #{chapter_number}" if @chapter.nil?

    blob = @chapter.csv_rows

    # put "blob ::::: #{blob}"

    ActiveRecord::Base.transaction do
      blob.each do |row|
        chapter_number = row['Chapter_Number'].to_i
        chapter_name = row['Chapter_Name'].try(:strip)
        chhand_type = row['Chhand_Type'].try(:strip)
        tuk = row['Tuk'].try(:strip)
        pauri_number = row['Pauri_Number'].to_i
        pauri_translation_en = row['Pauri_Translation_EN'].try(:strip)
        tuk_translation_en = row['Tuk_Translation_EN'].try(:strip)
        footnotes = row['Footnotes'].try(:strip) # Bhai Vir Singh footnotes
        extended_ref = row['Extended_Ref'].try(:strip)
        translator = row['Assigned_Singh'].try(:strip)
        extended_meaning = row['Extended_Meaning'].try(:strip)

        if @chapter.title != chapter_name
          message = "The name in Book #{sequence}, Chapter #{chapter_number} is " +
                    pastel.bold('presently') +
                    " '#{@chapter.title}'. The CSV says '#{chapter_name}'."
          prompt.say(message, :color => :yellow)
          answer = prompt.yes?("Do you want to continue and update this title to '#{chapter_name}'?")
          raise 'Aborted by user' unless answer
          @chapter.update(:title => chapter_name)
          Rails.logger.debug pastel.green("✓ Chapter #{chapter_number}'s title updated to '#{chapter_name}'")
        end

        @pauri = @chapter.pauris.find_by(:number => pauri_number)
        raise "Pauri not found: #{pauri_number}" if @pauri.nil?

        @tuk = @pauri.tuks.find_by('original_content LIKE ?', tuk)
        raise "Tuk not found: #{tuk}" if @tuk.nil?

        # CREATE `TukTranslation`
        if tuk_translation_en.present?
          if @pauri.translation.present?
            destroy_tuk_option = @tuk.translation.nil? ? 'Do not create `TukTranslation`' : 'Destroy existing `TukTranslation`'
            choices = [
              'Continue with the `TukTranslation` and KEEP the `PauriTranslation`, too!',
              'Destroy the existing `PauriTranslation`, and continue with only the `TukTranslation`',
              destroy_tuk_option += 'Keep the `PauriTranslation`',
              pastel.red('Abort')
            ]
            selected_choice = prompt.select('Choose an option:', choices)

            case selected_choice
            when choices[0]
              Rails.logger.debug pastel.green('✓ Continuing with both `TukTranslation` and `PauriTranslation`')
              @tuk_translation = @tuk.translation || TukTranslation.new(:tuk_id => @tuk.id)
              @tuk_translation.update(:en_translation => tuk_translation_en, :en_translator => translator)
              Rails.logger.debug pastel.green("✓ `TukTranslation` created or updated for Tuk #{tuk} - Pauri # #{pauri_number}")
            when choices[1]
              # Destroy `PauriTranslation` and continue with only `TukTranslation`
              Rails.logger.debug pastel.yellow('⚠️ Deleting the existing `PauriTranslation`')
              @tuk_translation = @tuk.translation || TukTranslation.new(:tuk_id => @tuk.id)
              @tuk_translation.update(:en_translation => tuk_translation_en, :en_translator => translator)
              Rails.logger.debug pastel.green("✓ `TukTranslation` created or updated for Tuk #{tuk} - Pauri # #{pauri_number}")

              pauri.translation.destroy
            when choices[2]
              # Destroy/ `TukTranslation` and continue with only `PauriTranslation`
              if @tuk.translation.present?
                Rails.logger.debug pastel.yellow('⚠️ Deleting the existing `TukTranslation`')
                @tuk.translation.destroy
              end
            when choices[3]
              raise 'Aborted by user'
            end
          else
            @tuk_translation = @tuk.translation || TukTranslation.new(:tuk_id => @tuk.id)
            @tuk_translation.update(:en_translation => tuk_translation_en, :en_translator => translator)
            Rails.logger.debug pastel.green("✓ `TukTranslation` created or updated for Tuk #{tuk} - Pauri # #{pauri_number}")
          end
        end

        # CREATE `PauriTranslation`
        next if pauri_translation_en.blank?
        pauri_translation = @pauri.translation || PauriTranslation.new(:pauri_id => @pauri.id)
        pauri_translation.update(:en_translation => pauri_translation_en, :en_translator => translator)
        Rails.logger.debug pastel.green("✓ `PauriTranslation` created or updated for Pauri # #{pauri_number}")
      end
    end
  end
end

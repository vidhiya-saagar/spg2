# frozen_string_literal: true

class ChaptersController < ApplicationController
  # GET /books/:book_id/chapters
  def index
    @book = Book.find(params[:book_id])
    @chapters = @book.chapters.released
    set_cache(@chapters)
  end

  # GET /chapters/:id
  def show
    @chapter = Chapter.released.find(params[:id])
    set_cache(@chapter)
  end

  # GET /chapters/:id/content
  def content
    @chapter = Chapter.released.find(params[:id])

    # The response includes nested tuks and translations that can change
    # independently of chapters.updated_at. Use a composite timestamp so
    # clients don't get a stale 304 after a tuk or translation is edited.
    composite_updated_at = [
      @chapter.updated_at,
      @chapter.tuks.maximum(:updated_at),
      @chapter.pauri_translations.maximum(:updated_at)
    ].compact.max

    set_cache(:etag => @chapter.cache_key_with_version, :last_modified => composite_updated_at)
  end

  # GET /chapters/:id/kathas
  def kathas
    @kathas = Chapter.released.find(params[:id]).kathas
    set_cache(@kathas)
  end
end

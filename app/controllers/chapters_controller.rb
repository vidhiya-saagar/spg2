# frozen_string_literal: true

class ChaptersController < ApplicationController
  # GET /books/:book_id/chapters
  def index
    @book = Book.find(params[:book_id])
    @chapters = @book.chapters.released
    cache_and_validate(@chapters)
  end

  # GET /chapters/:id
  def show
    @chapter = Chapter.released.find(params[:id])
    cache_and_validate(@chapter)
  end

  # GET /chapters/:id/content
  def content
    @chapter = Chapter.released.find(params[:id])
    cache_and_validate(@chapter)
  end

  # GET /chapters/:id/kathas
  def kathas
    @kathas = Chapter.released.find(params[:id]).kathas
    cache_and_validate(@kathas)
  end
end

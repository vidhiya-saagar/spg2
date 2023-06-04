# frozen_string_literal: true

class ChaptersController < ApplicationController
  def index
    @book = Book.find(params[:book_id])
    @chapters = @book.chapters.released
  end

  def show
    @chapter = Chapter.released.find(params[:id])
  end

  # /chapters/:id/content.json
  def content
    @chapter = Chapter.released.find(params[:id])
  end
end

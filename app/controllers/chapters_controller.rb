# frozen_string_literal: true

class ChaptersController < ApplicationController
  def index
    @book = Book.find(params[:book_id])
    @chapters = @book.released_chapters
  end

  def show
    @chapter = Chapter.find(params[:id])
  end
end

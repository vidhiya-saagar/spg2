# frozen_string_literal: true

class ChaptersController < ApplicationController
  # GET /books/:book_id/chapters.json
  def index
    @book = Book.find(params[:book_id])
    @chapters = @book.chapters.released
  end

  # GET /chapters/:id.json
  def show
    @chapter = Chapter.released.find(params[:id])
  end

  # GET /chapters/:id/content.json
  def content
    @chapter = Chapter.released.find(params[:id])
  end

  # GET /chapters/:id/kathas.json
  def kathas
    @kathas = Chapter.released.find(params[:id]).kathas
  end
end

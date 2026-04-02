# frozen_string_literal: true

class BooksController < ApplicationController
  def index
    @books = Book.released
    set_cache(@books)
  end

  def show
    @book = Book.released.find(params[:id])
    set_cache(@book)
  end
end

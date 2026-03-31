# frozen_string_literal: true

class BooksController < ApplicationController
  def index
    @books = Book.released
    cache_and_validate(@books)
  end

  def show
    @book = Book.released.find(params[:id])
    cache_and_validate(@book)
  end
end

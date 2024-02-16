# frozen_string_literal: true

class BooksController < ApplicationController
  # NOTE: Remember to see .jbuilder
  def index
    @books = Book.released
  end

  def show
    @book = Book.released.find(params[:id])
  end
end

# frozen_string_literal: true

class BooksController < ApplicationController
  # NOTE: Remember to see .jbuilder
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end
end

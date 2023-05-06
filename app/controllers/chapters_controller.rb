# frozen_string_literal: true

class ChaptersController < ApplicationController
  def index
    @book = Book.find(params[:book_id])
    @chapters = @book.chapters
    render :json => @chapters
  end

  def show
    @chapter = Chapter.find(params[:id])

    respond_to do |format|
      format.json { render 'content', :formats => :json, :handlers => [:jbuilder], :status => :ok }
    end
  end
end

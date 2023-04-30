# frozen_string_literal: true

class ChaptersController < ApplicationController
  def show
    @chapter = Chapter.find(params[:id])
    render :json => @chapter
  end
end

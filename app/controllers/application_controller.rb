# frozen_string_literal: true

require 'active_model/validations'

class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    render json: { error: 'Not found' }, status: :not_found
  end

  # Call this in actions where data changes infrequently.
  # Sends Cache-Control and, if the client's ETag/Last-Modified matches, returns 304.
  #
  # Usage:
  #   cache_and_validate(@book)                   # single record
  #   cache_and_validate(@books, max_age: 300)    # collection with custom TTL
  def cache_and_validate(resource, max_age: 3600)
    response.set_header('Cache-Control', "public, max-age=#{max_age}, stale-while-revalidate=60")
    fresh_when(resource)
  end
end

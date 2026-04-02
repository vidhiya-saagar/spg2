# frozen_string_literal: true

require 'active_model/validations'

class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  private

  def not_found
    render :json => { :error => 'Not found' }, :status => :not_found
  end

  # Sets Cache-Control and handles conditional GET (ETag + Last-Modified).
  # Returns 304 Not Modified when the client's cached version is still current.
  #
  # Usage:
  #   set_cache(@book)                          # single record
  #   set_cache(@books, :max_age => 300)        # collection with custom TTL
  #   set_cache(:etag => key, :last_modified => ts)  # explicit ETag/timestamp
  def set_cache(resource = nil, max_age: 3600, **fresh_when_opts)
    response.set_header('Cache-Control', "public, max-age=#{max_age}, stale-while-revalidate=60")

    if resource && fresh_when_opts.empty?
      fresh_when(resource, :public => true)
    else
      fresh_when(fresh_when_opts.merge(:public => true))
    end
  end
end

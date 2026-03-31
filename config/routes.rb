# frozen_string_literal: true

Rails.application.routes.draw do
  # All routes are JSON-only — no .json suffix needed, Accept header respected
  defaults format: :json do
    # Book routes
    get '/books',             to: 'books#index'
    get '/books/:id',         to: 'books#show'

    # Chapters nested under a book
    get '/books/:book_id/chapters', to: 'chapters#index'

    # Chapter routes
    get '/chapters/:id',         to: 'chapters#show'
    get '/chapters/:id/content', to: 'chapters#content'
    get '/chapters/:id/kathas',  to: 'chapters#kathas'
  end
end

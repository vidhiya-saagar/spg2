# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Chapter routes
  get '/chapters/:id', to: 'chapters#show'
  get '/chapters/:id/content', to: 'chapters#content'
  get '/chapters/:id/kathas', to: 'chapters#kathas'

  # Book routes
  get '/books', to: 'books#index'
  get '/books/:id', to: 'books#show'
  
  # Nested book chapters route
  get '/books/:book_id/chapters', to: 'chapters#index'
end

# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :chapters, :only => [:show] do 
    get 'content', on: :member
    get 'kathas', on: :member
  end
  
  resources :books, :only => [:index, :show]

  resources :books do
    resources :chapters, :only => [:index]
  end
end

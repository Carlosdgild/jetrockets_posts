# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: [:create]
  resources :posts, only: [:create]
  resources :ratings, only: [:create]
end

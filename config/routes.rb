# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: [:create]
  resources :posts, only: [:create] do
    get :top_n_posts, on: :collection
    get :post_by_authors, on: :collection
  end
  resources :ratings, only: [:create]
end

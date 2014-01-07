Rails.application.routes.draw do 
  resources :carts, only: [:show, :destroy]
  resources :cart_items, only: [:create, :update, :destroy]
end
Rails.application.routes.draw do
  root 'home#top'
  get 'home/about'

  devise_for :admins
  devise_for :users
  resources :users, only: [:show, :edit, :update]
  resources :posts, only: [:index, :show, :new, :create, :edit, :update]
  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]
    resources :posts, only: [:index, :show, :edit, :update]
    resources :tags, only: [:index, :edit, :update]
    resources :admins, only: [:show, :edit, :update]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

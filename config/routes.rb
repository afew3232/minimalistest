Rails.application.routes.draw do
  root 'home#top'
  get 'home/about'

  devise_for :admins
  devise_for :users

  resources :users, only: [:show, :edit, :update]
  post 'posts/confirm_new'
  post 'posts/confirm_edit'
  resources :posts, only: [:index, :show, :new, :create, :edit, :update]
  post 'favorites/create'
  delete 'favorites/destroy'

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]
    post 'posts/confirm_edit'
    resources :posts, only: [:index, :show, :edit, :update, :destroy]
    resources :tags, only: [:index, :edit, :update, :create, :destroy]
    resources :admins, only: [:show, :edit, :update]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

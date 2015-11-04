Myflix::Application.routes.draw do
  get     'ui(/:action)', controller: 'ui'
  get     'home', to: 'videos#index'
  get     'register', to: 'users#new'
  get     'signin', to: 'sessions#new'
  post    'signin', to: 'sessions#create'
  delete  'signout', to: 'sessions#destroy'
  get     'my_queue', to: 'queue_items#index'
  post    'update_queue', to: 'queue_items#update_queue'
  get     'people', to: 'friendships#index'
  root to: 'static_pages#home'
  
  resources :friendships, only: [:destroy, :create]
  resources :queue_items, only: [:create, :destroy]
  resources :videos do
    resources :reviews, only: [:new, :create]
    
    collection do 
      post 'search'
    end
  end
  
  resources :categories, only: :show
  resources :users, only: [:create, :show]
  
  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  get 'expired_token', to: 'password_resets#expired_token'
  
  resources :forgot_passwords, only: [:create]
  resources :password_resets, only: [:show, :create]
end

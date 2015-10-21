Myflix::Application.routes.draw do
  get     'ui(/:action)', controller: 'ui'
  get     'home', to: 'videos#index'
  get     'register', to: 'users#new'
  get     'signin', to: 'sessions#new'
  post    'signin', to: 'sessions#create'
  delete  'signout', to: 'sessions#destroy'
  get     'my_queue', to: 'queue_items#index'
  post    'update_queue', to: 'queue_items#update_queue'
  
  root to: 'static_pages#home'
  
  resources :queue_items, only: [:create, :destroy]
  resources :videos do
    resources :reviews, only: [:new, :create]
    
    collection do 
      post 'search'
    end
  end
  
  resources :categories, only: :show
  resources :users, only: [:create, :show]
end

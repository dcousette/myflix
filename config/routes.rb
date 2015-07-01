Myflix::Application.routes.draw do
  get  'ui(/:action)', controller: 'ui'
  get  'home', to: 'videos#index'
  get  'register', to: 'users#new'
  get  'signin', to: 'sessions#new'
  post 'signin', to: 'sessions#create'
  
  root to: 'static_pages#home'
  
  resources :videos do 
    collection do 
      post 'search'
    end
  end
  
  resources :categories, only: :show
  resources :users, only: [:create]
end

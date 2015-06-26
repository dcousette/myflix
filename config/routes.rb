Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  get 'home', to: 'videos#index'
  
  resources :videos do 
    collection do 
      post 'search'
    end
  end
  
  resources :categories, only: :show
end

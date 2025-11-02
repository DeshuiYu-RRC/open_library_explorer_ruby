Rails.application.routes.draw do
  # Root route - homepage shows all books
  root 'books#index'

  # Books routes
  resources :books, only: [:index, :show] do
    collection do
      get 'search'
    end
  end

  # Authors routes
  resources :authors, only: [:index, :show]

  # Subjects routes
  resources :subjects, only: [:index, :show]

  # About page
  get 'about', to: 'pages#about'
end
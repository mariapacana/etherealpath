Rails.application.routes.draw do
  root 'homepage#show'

  resources :users

  resources :missions do
    resources :god_messages, only: [:create]
  end

  resources :challenges, only: [:index] do
    resources :participants, only: [:index, :show]
  end

  resources :participants, only: [:index, :update] do
    resources :messages, only: [:index, :create]
  end

  match '/signup',  to: 'users#new', via: [:get]
  match '/signin',  to: 'sessions#new', via: [:get]
  match '/sessions',  to: 'sessions#create', via: [:post]
  match '/signout', to: 'sessions#destroy', via: [:get]

  match '/receive_sms', to: 'twilio#receive_sms', via: [:get, :post]

  match '/help', to: 'participants#index_help', via: [:get]
  match '/add_participants', to: 'missions#add_participants', via: [:post]
  get '/download_picture/:id', to: 'responses#download_picture', as: 'download_picture'

  get '/stats', to: 'stats#index', as: 'stats'

end

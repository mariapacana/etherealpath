Rails.application.routes.draw do
  root 'homepage#show'

  resources :missions do
    resources :god_messages
  end

  resources :participants do
    resources :messages
    resources :responses
  end

  resources :users
  match '/signup',  to: 'users#new', via: [:get]
  match '/signin',  to: 'sessions#new', via: [:get]
  match '/sessions',  to: 'sessions#create', via: [:post]
  match '/signout', to: 'sessions#destroy', via: [:get]

  match '/receive_sms', to: 'twilio#receive_sms', via: [:get, :post]

  match '/help', to: 'participants#index', via: [:get]
  match '/add_participants', to: 'missions#add_participants', via: [:post]
  get '/download_picture/:id', to: 'responses#download_picture', as: 'download_picture'

  get '/stats', to: 'stats#index', as: 'stats'

end

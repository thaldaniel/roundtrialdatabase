Rails.application.routes.draw do
  root 'users#login'
  resources :users do
    collection do 
      get :login
      post :auth
      get :logout
    end
  end
  resources :proceedings
  resources :proceeding_result_schemas
  resources :devices
  resources :participant_proceeding_results
  resources :participant_proceedings
  resources :participants
  resources :roundtrials do

  end
end

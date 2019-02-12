def create_routes(router)
  router.draw do

    root to: 'bands#index'

    resource :sessions, only: [:new, :create, :destroy]

    resources :users, only: [:show, :new, :create]

    resources :bands do
      collection do
        get :json
      end
      resources :albums, only: [:new]
    end

    resources :albums, only: [:show, :create, :edit, :update, :destroy] do
      resources :tracks, only: [:new]
    end

    resources :tracks, only: [:show, :create, :edit, :update, :destroy,]

    resources :notes, only: [:create, :destroy]
  end

end
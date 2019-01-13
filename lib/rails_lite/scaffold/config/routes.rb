def create_routes(router)
  router.draw do
    root to: 'cats#index'
    resources :cats
    resources :users, except: [:edit, :update]
    resource :sessions, only: [:new, :create, :destroy]
  end

end
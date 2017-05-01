Rails.application.routes.draw do
  root "main#index"

  get "auth/:provider/callback", to: "sessions#create"
  resource :session, only: [:new, :create, :destroy]

  namespace :freelancer do
    root "freelancers#show"

    resource :freelancer, only: [:show, :edit, :update]
  end

  namespace :company do
    root "companies#show"

    resource :company, only: [:show, :edit, :update]
    resources :projects, except: [:new, :create] do
      resources :jobs, except: [:index]
    end
    resources :jobs, except: [:index]
  end

  namespace :admin do
    root "main#index"

    resources :freelancers, except: [:new, :create] do
      get :login_as, on: :member
      get :disable, on: :member
      get :enable, on: :member
    end

    resources :companies, except: [:new, :create] do
      get :login_as, on: :member
      get :disable, on: :member
      get :enable, on: :member
    end
  end
end

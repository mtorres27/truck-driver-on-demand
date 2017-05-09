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
    resources :projects
    resources :jobs, except: [:index] do
      resources :applicants
      resource :contract, only: [:show, :edit, :update]
      resource :progress, only: [:show]
      resources :payments, only: [:index]
    end
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

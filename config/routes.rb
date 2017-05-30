Rails.application.routes.draw do
  root "main#index"

  get "auth/:provider/callback", to: "sessions#create"
  resource :session, only: [:new, :create, :destroy] do
    get :login_as, on: :collection
  end

  namespace :freelancer do
    root "freelancers#show"

    resource :freelancer, only: [:show, :edit, :update]
  end

  namespace :company do
    root "main#index"

    resource :company, only: [:show, :edit, :update]
    resources :freelancers, only: [:index, :show]
    resources :applicants

    namespace :postings do
      root "projects#index"
      resources :projects
      resources :jobs, except: [:index] do
        resources :applicants
        resource :contract, only: [:show, :edit, :update]
        resources :messages, only: [:index, :create]
        resources :payments, only: [:index, :show] do
          get :print, on: :member
          get :mark_as_paid, on: :member
        end
      end
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

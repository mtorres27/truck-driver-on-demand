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
    resources :freelancers, only: [:index, :show] do
      get :hired, on: :collection
    end
    resources :applicants
    resources :payments
    resources :projects

    resources :jobs, except: [:index] do
      resources :applicants do
        get :request_quote, on: :member
        get :ignore, on: :member
        resources :quotes, only: [:index, :create] do
          get :accept, on: :member
          get :decline, on: :member
        end
      end
      resource :contract, only: [:show, :edit, :update]
      resources :messages, only: [:index, :create]
      resources :payments, controller: "job_payments", only: [:index, :show] do
        get :print, on: :member
        get :mark_as_paid, on: :member
      end
      resource :review, only: [:show, :create]
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

    resources :audits, only: [:index]
  end
end

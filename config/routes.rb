Rails.application.routes.draw do
  devise_for :companies, path: 'company', path_names: { sign_in: "login", sign_up: "register" }
  devise_for :freelancers, path: 'freelancer', path_names: { sign_in: "login", sign_up: "register" }
  devise_for :admins, path: 'admin', path_names: { sign_in: "login", sign_up: "register" }


  root "main#index"

  get "company/login", to: "devise/session#new"
  get "privacy-policy", to: "pages#show", id: "privacy-policy"
  get "terms-of-service", to: "pages#show", id: "terms-of-service"

  namespace :freelancer do
    root "main#index"
    resource :freelancer, only: [:show, :edit, :update]

    resources :companies, only: [:index, :show] do
      get :favourites, on: :collection
      post :add_favourites, on: :collection
      get :av_companies, on: :collection
    end

    resources :jobs, only: [:index, :show] do
      get :favourites, on: :collection
      post :add_favourites, on: :collection
      get :my_jobs, on: :collection
      get :my_applications, on: :collection
      post :apply, on: :collection
      
      resources :application, only: [:index, :create]
      resource :contract, only: [:show, :accept], as: "work_order", path: "work_order"
      resources :messages, only: [:index, :create]    
      resources :payments, controller: "job_payments", only: [:index]
      resource :review, only: [:show, :create]  
      resources :quotes, only: [:index, :create] do
        get :accept, on: :member
        get :decline, on: :member
      end

    end
    resource :profile, only: [:show, :edit, :update] do
      resource :banking, only: [:index, :edit, :update, :verify, :update_verify]
      resource :settings, only: [:index, :edit, :update]

    end
    
    get "profile/banking", to: "banking#index"
    get "profile/settings", to: "settings#index"
    post "jobs/:id", to: "jobs#apply"
    post "job/apply", to: "jobs#apply"
    get "jobs/:id/work_order/accept", to: "contracts#accept"

    resources :notifications

  end

  namespace :company do
    root "main#index"

    resource :profile, only: [:show, :edit, :update]
    resources :freelancers, only: [:index, :show] do
      get :hired, on: :collection
      get :favourites, on: :collection
      post :add_favourites, on: :collection
    end
    resources :applicants
    resources :payments
    resources :projects

    resources :notifications

    resources :jobs, except: [:index] do
      resources :applicants do
        get :request_quote, on: :member
        get :ignore, on: :member
        resources :quotes, only: [:index, :create] do
          get :accept, on: :member
          get :decline, on: :member
        end
      end
      resource :contract, only: [:show, :edit, :update], as: "work_order", path: "work_order"
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
      get :disable, on: :member
      get :enable, on: :member
    end

    resources :companies, except: [:new, :create] do
      get :disable, on: :member
      get :enable, on: :member
    end

    resources :projects, except: [:new, :create] do
      get :disable, on: :member
      get :enable, on: :member
    end

    resources :jobs, except: [:new, :create] do
      get :disable, on: :member
      get :enable, on: :member
    end

    resources :pages, only: [:index, :edit, :update]
    resources :audits, only: [:index]
  end
end

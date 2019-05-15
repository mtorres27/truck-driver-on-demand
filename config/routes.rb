Rails.application.routes.draw do
  match '/login'                    => 'main#login',                  via: :get
  match '/company_register'         => 'main#company_register',       via: :get
  match '/search_professionals'     => 'main#search_professionals',   via: :get
  match '/messages'                 => 'main#messages',               via: :get
  match '/message_detail'           => 'main#message_detail',         via: :get
  match '/search_results'           => 'main#search_results',         via: :get
  match '/jobs'                     => 'main#jobs',                   via: :get
  match '/job_detail'               => 'main#job_detail',             via: :get
  match '/job_form'                 => 'main#job_form',               via: :get
  match '/company_profile'          => 'main#company_profile',        via: :get
  match '/company_profile_edit'     => 'main#company_profile_edit',   via: :get
  match '/company_user_edit'        => 'main#company_user_edit',      via: :get

  match '/avpro_profile'            => 'main#avpro_profile',          via: :get

  mount ActionCable.server => '/cable'

  devise_for :users, skip: [:registrations], controllers: {sessions: "sessions" }

  devise_for :company_users, path: 'company',
                             path_names: { sign_up: "register" },
                             controllers: {registrations: "company/registrations", sessions: "sessions" },
                             skip: [:devise, :passwords, :confirmations]

  devise_for :freelancers, path: 'freelancer',
                           path_names: { sign_up: "register" },
                           controllers: {registrations: "freelancer/registrations", sessions: "sessions" },
                           skip: [:devise, :passwords, :confirmations]

  devise_scope :company_user do
    match 'active'            => 'sessions#active',               via: :get
    match 'timeout'           => 'sessions#timeout',              via: :get
  end

  devise_scope :freelancer do
    match 'active'            => 'sessions#active',               via: :get
    match 'timeout'           => 'sessions#timeout',              via: :get
  end

  devise_scope :admin do
    match 'active'            => 'sessions#active',               via: :get
    match 'timeout'           => 'sessions#timeout',              via: :get
  end

  root "main#index"

  get "freelance-service-agreement", to: "main#freelance_service_agreement"
  get "confirm_email", to: "main#confirm_email"
  get "job_country_currency", to: "main#job_countries", as: "job_country_currency"

  resources :notifications, only: [:show]

  namespace :freelancer do

    root "main#index"
    resource :freelancer, only: [:show]

    resources :registration_steps, only: [:show, :update, :index] do
      member do
        post :skip
      end
    end

    resources :companies, only: [:index, :show] do
      get :favourites, on: :collection
      post :add_favourites, on: :collection
      get :av_companies, on: :collection
      resources :messages, only: [:index, :create]
    end

    resources :jobs, only: [:index, :show] do
      get :favourites, on: :collection
      post :add_favourites, on: :collection
      get :my_jobs, on: :collection
      get :my_applications, on: :collection
      get :job_matches, on: :collection
      post :apply, on: :collection

      resources :application, only: [:index, :create]
      resource :contract, only: [:show, :accept], as: "work_order", path: "work_order"
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

    resources :messaging, only: [:index]

    get "profile/bank_info", to: "banking#index", as: "profile_stripe_banking_info"
    get "profile/identity", to: "banking#identity", as: "profile_stripe_banking"
    get "profile/bank_account", to: "banking#bank_account", as: "profile_stripe_bank_account"
    post "stripe/connect", to: "banking#connect", as: "stripe_connect"
    post "stripe/bank", to: "banking#add_bank_account", as: "stripe_bank_submit"
    get "profile/settings", to: "settings#index"
    post "jobs/:id", to: "jobs#apply"
    post "job/apply", to: "jobs#apply"
    get "jobs/:id/work_order/accept", to: "contracts#accept"
  end

  namespace :company do
    root "main#index"

    resource :profile, only: [:show, :edit, :update]
    resources :registration_steps, only: [:show, :update, :index] do
      member do
        post :skip
      end
    end

    resources :freelancers, only: [:show, :index] do
      get :saved, on: :collection
      get :hired, on: :collection
      post :add_favourites, on: :collection
      post :save_freelancer, on: :member
      post :delete_freelancer, on: :member
      resources :messages, only: [:index, :create]
    end

    resources :company_users, only: [:index, :show, :new, :create, :destroy, :edit, :update] do
      post :disable, on: :member
      post :enable, on: :member
    end

    get "freelancers/:id/invite_to_quote", to: "freelancers#invite_to_quote"

    resources :applicants
    resources :projects
    resources :messaging, only: [:index]

    get 'job_country_currency', to: 'jobs#job_countries', as: 'job_country_currency'

    resources :jobs, except: [:index] do
      resources :job_build, only: [:index, :show, :update, :create] do
        member do
          post :skip
        end
      end
      resources :applicants do
        get :request_quote, on: :member
        get :ignore, on: :member
        resources :quotes, only: [:index, :create] do
          get :accept, on: :member
          get :decline, on: :member
        end
      end
      resource :review, only: [:show, :create]
      get :collaborators, on: :member
      get :contract_invoice, on: :member
      get :freelancer_matches, on: :member
      post :mark_as_finished, on: :member
    end

    post "jobs/:id/add_collaborator/:company_user_id", to: "jobs#add_collaborator"
    post "jobs/:id/remove_collaborator/:company_user_id", to: "jobs#remove_collaborator"
    post "jobs/:id/unsubscribe_collaborator/:company_user_id", to: "jobs#unsubscribe_collaborator"
    post "jobs/:id/subscribe_collaborator/:company_user_id", to: "jobs#subscribe_collaborator"
    get "jobs/:id/publish", to: "jobs#publish"
  end

  namespace :admin do
    root "main#index"

    resources :freelancers, except: [:new, :create] do
      get :disable, on: :member
      get :enable, on: :member
    end

    resource :freelancer do
      get :download_csv
    end

    resources :companies, except: [:new, :create] do
      get :disable, on: :member
      get :enable, on: :member
      get :jobs
    end

    resource :company do
      get :download_csv
    end

    resources :projects, except: [:new, :create] do
      get :disable, on: :member
      get :enable, on: :member
    end

    resources :jobs, except: [:new, :create] do
      get :freelancer_matches, on: :member
      get :mark_as_expired, on: :member
      get :unmark_as_expired, on: :member
      resources :applicants
      resource :contract, only: [:show, :edit, :update], as: "work_order", path: "work_order"
      resources :messages, only: [:index, :create]
      resource :review, only: [:show, :create]
    end

    resources :pages, only: [:index, :edit, :update]
    resources :audits, only: [:index]

    resources :new_registrants, only: [:index]
    resource :new_registrant, only: [:download_csv] do
      get :download_csv
    end
    resources :incomplete_registrations, only: [:index]
    resource :incomplete_registration, only: [:download_csv] do
      get :download_csv
    end
  end

  get "*any", via: :all, to: "errors#not_found"
  get "*any", via: :all, to: "errors#unauthorized"
end

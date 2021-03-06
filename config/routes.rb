# encoding: utf-8
Bookcamp::Application.routes.draw do

  root to: "camp_shelves#index"

  # THIS IS PUBLIC
  scope path_names: {new: 'nueva', edit: 'modificar'} do

    # Camp Shelves
    resources :camp_shelves, path: 'estanterias' do
      resources :shelf_items, path: 'referencias'
      resources :references, path: 'referencia', only: [:show, :new]
      resources :memberships, path: 'colaboradoras'
    end

    # User Shelves
    resources :user_shelves, path: 'listas' do
      resources :shelf_items, path: 'referencias'
      resources :memberships, path: 'colaboradoras'
      resources :references, path: 'referencia', only: [:show, :new]
    end

    # References
    resources :references, path: 'referencia', except: [:index] do
      scope module: 'references' do
        resources :comments, only: [:create]
        resources :shelf_items, path: 'listas'
        resources :taggings
      end
    end

    # Publishers
    resources :publishers, path: 'editoriales' do
      resources :published_references, path: 'referencias'
    end

    # Model Controllers
    resources :tags
    resources :versions, path: 'actividad' do
      get :email, on: :collection
    end
    resources :licenses, path: 'licencias'
    resources :colors, path: 'colores'
    resources :camps, path: 'campings'

    scope module: 'public' do
      resources :password_recoveries, path: 'recuperar', except: [:index] do
        post :change, on: :collection
      end
    end
    match '/recuperar/token/:id' => 'public/password_recoveries#recover', as: 'recovery'

    resources :users, path: 'somos' do
      get :search, on: :collection, path: 'buscar'
      resources :memberships, path: 'colaboradoras'
    end
  end

  #resources :blog_redirect, only: [:index, :show], path: 'blog'
  scope module: 'blog' do
    resources :posts, path: 'blog' do
      get :archive, on: :collection
      resources :comments
    end
  end

  WaxMuseum::Routes.draw


  match "/clismon/pnh" => 'publishers/clismon#pnh'

  match "/identificar" => "public/sessions#create"
  match "/entrar" => "public/sessions#new", as: :login
  match "/auth/:provider/callback" => "public/sessions#create_with_omniauth"
  match "/salir" => "public/sessions#destroy", :as => :logout
  match "/entrar/:id" => "public/sessions#new", :as => :auth
  match "/auth/failure" => "public/sessions#failure"

  match "/buscar/:term" => "references#search", :as => :search
  match "/buscar" => "references#search"

  ['mapa', 'cuatrocientoscuatro', 'quinientos', 'sopa'].each do |name|
    match "/#{name}" => "public/screens##{name}"
  end

  # Backdoors used in test and development
  match "/enter/:id" => "public/sessions#enter", :as => :enter unless Rails.env.production?
  match "/gocamp/:id" => "camps#enter", :as => :gocamp

end


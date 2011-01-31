AlteredBeast::Application.routes.draw do
  get '/session' => "sessions#create",
    :as => 'open_id_complete'

  resources :sites, :moderatorships, :monitorship

  resources :forums, :has_many => :posts do
    resources :topics do |topic|
      resources :posts
      resource :monitorship
    end
    resources :posts
  end

  resources :posts do
    get :search, :on => :collection
  end
  resources :users do
    member do
      put :suspend, :make_admin, :unsuspend
      get :settings
      delete :purge
    end
    resources :posts, :only => [:index]
  end

  match '/activate/:activation_code' => 'users#activate', :activation_code => nil, :as => 'activate'
  match '/signup' => 'users#new', :as => 'signup'
  match '/settings' => 'users#settings', :as => 'settings'
  match '/login' => 'sessions#new', :as => 'login'
  match '/logout' => 'sessions#destroy', :as => 'logout'

  resource  :session

  # map.with_options :controller => 'posts', :action => 'monitored' do |map|
  #   map.formatted_monitored_posts 'users/:user_id/monitored.:format'
  #   map.monitored_posts           'users/:user_id/monitored'
  # end

  root :to => 'forums#index'
end

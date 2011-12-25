Campusapp::Application.routes.draw do
  get 'log_out'			 	=> 'sessions#destroy', 			:as => 'log_out'
  get 'log_in' 					=> 'sessions#new', 					:as => 'log_in'
  get 'sign_up' 				=> 'user_profiles#new', 			:as => 'sign_up'
  get 'dashboard'			=> 'homes#home',					 :as => 'dashboard'
  resources :sessions
  resources :password_resets
  resources :user_profiles
  resources :branches do 
    member do
      get 'facultynew'
      put 'facultycreate'
      get 'clazznew'
      put 'clazzcreate'      
      get 'subjectnew'
      put 'subjectcreate'
    end 	
  end
  resources :faculties
  resources :clazzs
  resources :subjects
  root :to => 'sessions#new'
end

Campusapp::Application.routes.draw do
  get "students/index"

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
      get 'examnew'
      put 'examcreate'
  	  get 'studentnew'  
  	  put 'studentcreate'      
    end 	
  end
  resources :faculties
  resources :clazzs do
    member do
      get 'sectionnew'
      put 'sectioncreate'
    end
    collection do
      get 'select'
    end
  end
  resources :subjects
  resources :exams
  resources :sections do
    collection do
      get 'select'
    end
    member do
      get 'assign_students'
	end
  end
  resources :students
  root :to => 'sessions#new'
end

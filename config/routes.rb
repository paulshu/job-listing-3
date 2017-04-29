Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations" }

  namespace :admin do
    resources :jobs do
      member do
        post :publish
        post :hide
      end
      resources :resumes

    end
  end

  namespace :favorite do
    resources :jobs
  end

  namespace :account do
    resources :users
  end

  resources :jobs do
    member do
      post :favorites  #因与上面的favorite同名，出现routes错误，此处改名处理
      post :unfavorite
    end

    resources :resumes
    collection do
      get :search
    end
  end

  root 'welcome#index'
end

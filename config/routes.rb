Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  resources :students do
    post :approve_student, on: :member
  end
  resources :institutions
  root to: "home#index"
  get :register, to: 'students#register'
  post :register_student, to: 'students#register_student'
  get :pending_students, to: 'students#pending_students'
end

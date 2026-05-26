Rails.application.routes.draw do
  get "handoff_documents/show"
  get "handoff_documents/new"
  get "handoff_documents/create"
  get "handoff_documents/edit"
  get "handoff_documents/update"
  get "repositories/show"
  get "repositories/new"
  get "repositories/create"
  get "repositories/edit"
  get "repositories/update"
  get "repositories/destroy"
  get "projects/index"
  get "projects/show"
  get "projects/new"
  get "projects/create"
  get "projects/edit"
  get "projects/update"
  get "projects/destroy"
  root "projects#index"

  resources :projects do
    resources :repositories, only: [:new, :create]
  end

  resources :repositories, only: [:show, :edit, :update, :destroy] do
    resource :handoff_document, only: [:new, :create, :show, :edit, :update]
  end
end
Rails.application.routes.draw do
  get 'static_pages/about'
  get 'static_pages/help'

  mount Ckeditor::Engine => '/ckeditor'
  devise_for :admins
  root to: "collab_projects#index"
  
  resources :posts
  resources :videos, only: [:index, :new, :create]
  resources :video_uploads, only: [:new, :create]
  resources :source_texts, only: [:create, :edit]
  resources :source_youtubes, only: [:create, :edit]
  resources :comments, only: [:new, :create, :destroy]

  resources :collab_projects do
    resources :branches
    resources :collaborators, only: [:new, :create]

    resources :branches do
      get 'new_child_branch', to: 'branches#new'
      post 'add_leaf', to: 'leafs#create'
      patch 'edit_leaf', to: 'leafs#edit'
      #resources :comments, only: [:index, :new, :create, :destroy]
      #get '/comments/new/(:parent_id, :branch_id)', to: 'comments#new', as: :new_comment
      patch 'edit_yt', to: 'source_youtubes#edit_yt'
      patch 'edit_text', to: 'source_texts#edit_text'
      resources :leafs

      resources :leafs do
        collection do
          post 'set_source_type', to: 'leafs#set_source_type'
        end

        post 'create', to: 'leafs#create'
      end
    end
  end

  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: :logout


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

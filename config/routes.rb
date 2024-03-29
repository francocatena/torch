Torch::Application.routes.draw do
  match 'feedbacks/:hint_id/:score' => 'feedbacks#create', as: 'new_feedback',
    via: :post, score: /positive|negative/
  match 'feedbacks/:id' => 'feedbacks#update', as: 'update_feedback',
    via: :put

  resources :user_sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end
  
  match 'admin' => 'user_sessions#new', as: :admin

  resources :users

  resources :images
  
  resources :apps do
    resources :hints do
      member do
        get :history
      end
    end
    
    get :tags, on: :member, defaults: { format: 'json' }
  end
  
  match '/apps/:app_id/hints/:id/diff/:version_id' => 'hints#diff',
    as: 'diff_app_hint', via: :get

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root to: 'apps#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
Spree::Core::Engine.add_routes do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      post '/sign_up', action: :sign_up, controller: 'users'
      post '/sign_in', action: :sign_in, controller: 'users'
    end
    # resource :users do
    #   post :sign_up
    #   post :sign_in
    # end
  end
end

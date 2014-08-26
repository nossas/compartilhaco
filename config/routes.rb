Rails.application.routes.draw do
  resources :campaigns do
    member do
      get 'images/:trash', to: 'campaigns#serve_image', as: :serve_image
    end
  end

  resources :campaign_spreaders do
    collection do
      post(
        'create_for_facebook_profile',
        to: 'campaign_spreaders#create_for_facebook_profile',
        as: :create_for_facebook_profile
      )

      post(
        'create_for_twitter_profile',
        to: 'campaign_spreaders#create_for_twitter_profile',
        as: :create_for_twitter_profile
      )
    end
  end

  get '/auth/facebook/callback', to: 'campaign_spreaders#create_for_facebook_profile_callback'
  get '/auth/twitter/callback', to: 'campaign_spreaders#create_for_twitter_profile_callback'
  get '/auth/failure', to: 'campaign_spreaders#failure'
end

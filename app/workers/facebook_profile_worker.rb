class FacebookProfileWorker
  include Sidekiq::Worker

  def perform facebook_profile_id
    facebook_profile = FacebookProfile.find(facebook_profile_id)
    facebook_profile.fetch_friends_count
    facebook_profile.fetch_subscribers_count
  end
end

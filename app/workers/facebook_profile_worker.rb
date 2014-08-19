class FacebookProfileWorker
  include Sidekiq::Worker

  def perform facebook_profile_id
    FacebookProfile.find(facebook_profile_id).fetch_friends_count
  end
end

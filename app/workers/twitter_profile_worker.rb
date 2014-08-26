class TwitterProfileWorker
  include Sidekiq::Worker

  def perform twitter_profile_id
    twitter_profile = TwitterProfile.find(twitter_profile_id)
    twitter_profile.fetch_followers_count
  end
end

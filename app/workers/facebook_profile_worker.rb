class FacebookProfileWorker
  include Sidekiq::Worker

  def perform facebook_profile
    facebook_profile.fetch_friends_count
  end
end

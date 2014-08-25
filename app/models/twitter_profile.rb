class TwitterProfile < Timeline
  belongs_to :user
  after_create { TwitterProfileWorker.perform_async(self.id) }

  validates :user_id, :uid, :token, :secret, presence: true
  validates :user_id, uniqueness: true
  validates :uid, uniqueness: true

  def fetch_followers_count
    # begin
    puts api.user.followers_count
    #   update_attribute :followers_count, result
    # rescue
    #   logger.warn result.inspect
    # end
  end

  def api
    @api ||= Twitter::REST::Client.new do |config|
      config.consumer_key = self.token
      config.consumer_secret = self.secret
      config.access_token = ENV['TWITTER_KEY']
      config.access_token_secret = ENV['TWITTER_SECRET']
    end
  end
end

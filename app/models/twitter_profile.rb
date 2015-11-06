class TwitterProfile < Timeline
  belongs_to :user
  after_create { TwitterProfileWorker.perform_async(self.id) }

  validates :user_id, :uid, :token, :secret, presence: true
  validates :user_id, uniqueness: true
  validates :uid, uniqueness: true

  def service
    :twitter
  end

  def fetch_followers_count
    update_attribute :followers_count, api.user.followers_count
  rescue Exception => e
    logger.warn e.message
  end

  def share campaign_spreader
    begin
      result = api.update(campaign_spreader.message)
      campaign_spreader.update_attribute :uid, result.id
    rescue Exception => e
      puts e.message
      Appsignal.add_exception e
      logger.warn e.message
    end
  end

  def api
    @api ||= Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_KEY']
      config.consumer_secret = ENV['TWITTER_SECRET']
      config.access_token = self.token
      config.access_token_secret = self.secret
    end
  end
end

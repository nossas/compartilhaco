class FacebookProfile < Timeline
  belongs_to :user
  after_create { FacebookProfileWorker.perform_async(self.id) }

  validates :user_id, :uid, :token, :expires_at, presence: true
  validates :uid, uniqueness: true
  validates :user_id, uniqueness: true

  def fetch_friends_count
    result = graph.api("me/friends")
    if result["error"]
      logger.warn result.inspect
    else
      update_attribute :friends_count, result["summary"]["total_count"]
    end
  end

  def fetch_subscribers_count
    result = graph.api("me/subscribers")
    if result["error"]
      logger.warn result.inspect
    else
      update_attribute :subscribers_count, result["summary"]["total_count"]
    end
  end

  def share campaign_spreader
    begin
      result = graph.put_connections("me", "feed",
        message: campaign_spreader.message,
        link: campaign_spreader.campaign.share_link
      )
      campaign_spreader.update_attribute :uid, result["id"]
    rescue Koala::Facebook::AuthenticationError => e
      logger.warn e.message
    end
  end

  def graph
    @graph ||= Koala::Facebook::API.new(token)
  end
end

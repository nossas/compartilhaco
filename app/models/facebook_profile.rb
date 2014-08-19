class FacebookProfile < Timeline
  belongs_to :user
  after_create { FacebookProfileWorker.perform_async(self.id) }

  def fetch_friends_count
    graph = Koala::Facebook::API.new(token)
    result = graph.api("me/friends")
    if result["error"]
      logger.warn result.inspect
    else
      update_attribute :friends_count, result["summary"]["total_count"]
    end
  end

  def fetch_subscribers_count
    graph = Koala::Facebook::API.new(token)
    result = graph.api("me/subscribers")
    if result["error"]
      logger.warn result.inspect
    else
      update_attribute :subscribers_count, result["summary"]["total_count"]
    end
  end

  def share campaign_spreader
    graph = Koala::Facebook::API.new(token)
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
end

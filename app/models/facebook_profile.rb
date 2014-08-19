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
end

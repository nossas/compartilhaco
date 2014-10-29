class FacebookProfile < Timeline
  belongs_to :user
  after_create { FacebookProfileWorker.perform_async(self.id) }

  validates :user_id, :uid, :token, :expires_at, presence: true
  validates :uid, uniqueness: true
  validates :user_id, uniqueness: true

  include Rails.application.routes.url_helpers

  def service
    :facebook
  end

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
        link: campaign_spreader.campaign.share_link,
        picture: serve_image_campaign_url(campaign_spreader.campaign, SecureRandom.hex),
        name: campaign_spreader.campaign.facebook_title,
        description: campaign_spreader.campaign.facebook_message
      )
      campaign_spreader.update_attribute :uid, result["id"]
    rescue Exception => e
      Appsignal.add_exception e
      logger.warn e.message
    end
  end

  def check_expired_token
    begin
      Koala::Facebook::API.new(token).get_object('me')
    rescue Koala::Facebook::AuthenticationError => e
      update_attribute :expires_at, Time.zone.now
      logger.warn e.message
    end
  end

  def graph
    @graph ||= Koala::Facebook::API.new(token)
  end
end

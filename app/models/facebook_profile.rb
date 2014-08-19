class FacebookProfile < Timeline
  belongs_to :user
  after_create { self.fetch_friends_count }

  def fetch_friends_count
    begin
      graph = Koala::Facebook::API.new(token)
      count = graph.get_object("me", fields: "friends")["friends"]["summary"]["total_count"]
      update_attribute :friends_count, count
    rescue Koala::Facebook::AuthenticationError => e
      logger.warn e.message
    end
  end
end

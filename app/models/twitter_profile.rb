class TwitterProfile < Timeline
  belongs_to :user
  after_create { TwitterProfileWorker.perform_async(self.id) }

  validates :user_id, :uid, :token, presence: true
  validates :user_id, uniqueness: true
  validates :uid, uniqueness: true

  def fetch_followers_count
  end
end

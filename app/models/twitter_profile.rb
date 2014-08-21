class TwitterProfile < Timeline
  belongs_to :user
  validates :user_id, :uid, :token, presence: true
  validates :user_id, uniqueness: true
  validates :uid, uniqueness: true
end

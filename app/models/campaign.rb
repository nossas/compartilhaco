class Campaign < ActiveRecord::Base
  has_many :campaign_spreaders
  has_many :facebook_profiles, through: :campaign_spreaders, source: :timeline, source_type: "FacebookProfile"
  has_many :twitter_profiles, through: :campaign_spreaders, source: :timeline, source_type: "TwitterProfile"
  belongs_to :organization
  belongs_to :user
  belongs_to :category
  mount_uploader :image, ImageUploader
  mount_uploader :share_image, ImageUploader

  validates :ends_at, :share_link, :goal, :organization_id, :image, :title, :description, :user_id, :short_description, :share_image, :share_title, :share_description, :tweet, presence: true
  validate :ends_at_cannot_be_in_the_past
  validate :ends_at_cannot_be_in_more_than_50_days
  validates_length_of :short_description, maximum: 250

  scope :unshared,  -> { where("shared_at IS NULL") }
  scope :upcoming,  -> { where("? < ends_at", Time.now) }
  scope :ended,     -> { where("? >= ends_at", Time.now) }
  scope :succeeded, -> { where("(
    SELECT count(*)
    FROM campaign_spreaders
    WHERE campaign_spreaders.campaign_id = campaigns.id) >= campaigns.goal")}

  def share
    campaign_spreaders.each {|cs| cs.share}
    update_attribute :shared_at, Time.now
  end

  def ends_at_cannot_be_in_the_past
    errors.add(:ends_at, I18n.t("errors.messages.cannot_be_in_the_past")) if
      ends_at.nil? || ends_at < Time.now
  end

  def ends_at_cannot_be_in_more_than_50_days
    errors.add(:ends_at, I18n.t("errors.messages.cannot_be_in_more_than", 50.days)) if
      ends_at.nil? || ends_at > 50.days.from_now
  end

  def check_expired_tokens
    facebook_profiles.each { |fp| fp.check_expired_token }
  end

  def progress_of_goal
    campaign_spreaders.count.to_f/goal.to_f * 100
  end

  def progress_of_time
    (Time.now - created_at)/(ends_at - created_at) * 100
  end

  def reach
    facebook_profiles.sum(:friends_count) +
      facebook_profiles.sum(:subscribers_count) +
      twitter_profiles.sum(:followers_count)
  end
end

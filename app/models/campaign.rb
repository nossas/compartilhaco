class Campaign < ActiveRecord::Base
  has_many :campaign_spreaders
  belongs_to :organization
  belongs_to :user
  mount_uploader :image, ImageUploader

  validates :ends_at, :share_link, :goal, :organization_id, :image, :title, :description, :user_id, presence: true
  validate :ends_at_cannot_be_in_the_past
  validate :ends_at_cannot_be_in_more_than_50_days

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

  def facebook_profiles
    FacebookProfile.joins(:campaign_spreaders).where(campaign_spreaders: { campaign_id: self.id })
  end

  def check_expired_tokens
    facebook_profiles.each { |fp| fp.check_expired_token }
  end
end

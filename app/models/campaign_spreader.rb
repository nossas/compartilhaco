class CampaignSpreader < ActiveRecord::Base
  belongs_to :timeline, polymorphic: true
  belongs_to :campaign

  validates :timeline_id, :timeline_type, :campaign_id, presence: true
  validates :timeline_id, uniqueness: { scope: [:timeline_type, :campaign_id] }

  scope :facebook_profiles, -> { where timeline_type: 'FacebookProfile' }

  def share
    timeline.share(self)
  end
end

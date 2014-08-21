class CampaignSpreader < ActiveRecord::Base
  belongs_to :timeline, polymorphic: true
  belongs_to :campaign

  validates :timeline_id, :timeline_type, :campaign_id, presence: true
  validates :timeline_id, uniqueness: { scope: [:timeline_type, :campaign_id] }
  validates_length_of :message, maximum: 140, if: :facebook?

  def share
    timeline.share(self)
  end

  def facebook?
    timeline_type == "FacebookProfile"
  end
end

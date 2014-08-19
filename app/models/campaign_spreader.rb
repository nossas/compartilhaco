class CampaignSpreader < ActiveRecord::Base
  belongs_to :timeline, polymorphic: true
  belongs_to :campaign

  def share
    timeline.share(self)
  end
end

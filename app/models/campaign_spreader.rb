class CampaignSpreader < ActiveRecord::Base
  belongs_to :timeline, polymorphic: true
  belongs_to :campaign
end

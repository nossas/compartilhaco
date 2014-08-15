class CampaignSpreader < ActiveRecord::Base
  belongs_to :timeline, polymorphic: true
end

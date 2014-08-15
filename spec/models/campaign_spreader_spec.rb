require 'rails_helper'

RSpec.describe CampaignSpreader, :type => :model do
  it { should belong_to :timeline }
  it { should belong_to :campaign }
end

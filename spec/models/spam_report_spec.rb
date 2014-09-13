require 'rails_helper'

RSpec.describe SpamReport, :type => :model do
  before { SpamReport.make! }
  
  it {should belong_to :user}
  it {should belong_to :campaign}
  it {should validate_uniqueness_of(:user_id).scoped_to(:campaign_id)}
end

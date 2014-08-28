require 'rails_helper'

feature "View the campaign's total spreaders", :type => :feature do
  let(:campaign) { Campaign.make! }

  scenario "should see the campaign's total spreaders count" do
    visit campaign_path(campaign)
    expect(page).to have_css("total-spreaders-count", campaign.campaign_spreaders.count)
  end

  scenario "should see the campaign's target" do
    visit campaign_path(campaign)
    expect(page).to have_css("total-spreaders-target", campaign.target)
  end
end

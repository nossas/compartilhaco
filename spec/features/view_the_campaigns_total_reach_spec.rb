require 'rails_helper'

feature "View the campaign's total reach", :type => :feature do
  let(:campaign) { Campaign.make! }

  scenario "should see the campaign's total reach" do
    visit campaign_path(campaign)
    expect(page).to have_css(".reach", campaign.reach)
  end
end

require 'rails_helper'

feature "View the campaign's details", :type => :feature do
  let(:campaign) { Campaign.make! }

  scenario "should see the campaign's title" do
    visit campaign_path(campaign)
    expect(page).to have_css("h2", campaign.title)
  end

  scenario "should see the campaign's image" do
    visit campaign_path(campaign)
    expect(page).to have_css("img", campaign.image.url)
  end

  scenario "should see the campaign's description" do
    visit campaign_path(campaign)
    expect(page).to have_content(campaign.description)
  end
end

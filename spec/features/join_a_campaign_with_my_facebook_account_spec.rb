require 'rails_helper'

feature "Join a campaign with my Facebook account", :type => :feature do
  let(:campaign){ Campaign.make! }

  scenario "when I allow access to my Facebook account" do
    visit campaign_path(campaign)
    click_link "join-campaign-with-facebook"
  end

  scenario "when I don't allow access to my Facebook account" do
  end
end

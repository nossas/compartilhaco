require 'rails_helper'
include ActionView::Helpers::DateHelper

feature "View the campaign's details", :type => :feature do
  let(:campaign) { Campaign.make! }
  let(:spreader) { CampaignSpreader.make! :facebook_profile, campaign: campaign }

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

  scenario "should see the campaign's creator" do
    visit campaign_path(campaign)
    expect(page).to have_css("small", campaign.user.name)
  end

  scenario "should see the campaign's category" do
    visit campaign_path(campaign)
    expect(page).to have_css(".category", campaign.category.name)
  end

  scenario "should see the campaign's end date" do
    visit campaign_path(campaign)
    expect(page).to have_css(".ends-at-distance", distance_of_time_in_words_to_now(campaign.ends_at))
  end

  scenario "should see the campaign's short description" do
    visit campaign_path(campaign)
    expect(page).to have_css(".short-description", campaign.tweet)
  end

  scenario "should see the campaign's last spreaders" do
    visit campaign_path(campaign)
    expect(page).to have_css(".last-spreaders", spreader.user.name)
  end

  context "when the campaign is ended" do
    before { campaign.update_column(:ends_at, 1.day.ago) }

    context "when the campaign is succeeded" do
      before { campaign.goal.times { CampaignSpreader.make! :facebook_profile, campaign: campaign } }

      it "should show the succeeded campaign message" do
        visit campaign_path(campaign)
        expect(page).to have_css(".succeeded")
      end
    end

    context "when the campaign is unsucceeded" do
      it "should show the unsucceeded campaign message" do
        visit campaign_path(campaign)
        expect(page).to have_css(".unsucceeded")
      end
    end
  end

  context "when the campaign is archived" do
    before { campaign.archive }
    it "should show the archived campaign message" do
      visit campaign_path(campaign)
      expect(page).to have_css(".archived")
    end
  end
end

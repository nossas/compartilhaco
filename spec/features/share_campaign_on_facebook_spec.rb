require 'rails_helper'

feature "Share campaign on Facebook", :type => :feature do
  let(:campaign) { Campaign.make! }

  scenario "should have title tag" do
    visit campaign_path(campaign)
    expect(page).to have_title(campaign.title)
  end

  scenario "should have description meta tag" do
    visit campaign_path(campaign)
    expect(page).to have_css("meta[name='description'][content='#{campaign.short_description}']", visible: false)
  end

  scenario "should have og:title meta tag" do
    visit campaign_path(campaign)
    expect(page).to have_css("meta[property='og:title'][content='#{campaign.title}']", visible: false)
  end

  scenario "should have og:description meta tag" do
    visit campaign_path(campaign)
    expect(page).to have_css("meta[property='og:description'][content='#{campaign.short_description}']", visible: false)
  end

  scenario "should have og:url meta tag" do
    visit campaign_path(campaign)
    expect(page).to have_css("meta[property='og:url'][content='#{campaign_url(campaign)}']", visible: false)
  end

  scenario "should have og:image meta tag" do
    visit campaign_path(campaign)
    expect(page).to have_css("meta[property='og:image'][content='#{campaign.image.url}']", visible: false)
  end

  scenario "should see the Facebook share button", js: true do
    visit campaign_path(campaign, anchor: 'share')
    expect(page).to have_css("a.share-on-facebook-button")
  end
end

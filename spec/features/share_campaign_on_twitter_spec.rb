require 'rails_helper'

feature "Share campaign on Twitter", :type => :feature do
  let(:campaign) { Campaign.make! }

  scenario "should have twitter:card meta tag" do
    visit campaign_path(campaign)
    expect(page).to have_css("meta[name='twitter:card'][content='summary']", visible: false)
  end

  scenario "should have twitter:title meta tag" do
    visit campaign_path(campaign)
    expect(page).to have_css("meta[name='twitter:title'][content='#{campaign.title}']", visible: false)
  end

  scenario "should have twitter:description meta tag" do
    visit campaign_path(campaign)
    expect(page).to have_css("meta[name='twitter:description'][content='#{campaign.short_description}']", visible: false)
  end

  scenario "should have twitter:image meta tag" do
    visit campaign_path(campaign)
    expect(page).to have_css("meta[name='twitter:image'][content='#{campaign.image.thumb.url}']", visible: false)
  end

  scenario "should have twitter:url meta tag" do
    visit campaign_path(campaign)
    expect(page).to have_css("meta[name='twitter:url'][content='#{campaign_url(campaign)}']", visible: false)
  end

  scenario "should have twitter:site meta tag" do
    visit campaign_path(campaign)
    expect(page).to have_css("meta[name='twitter:site'][content='@meu_rio']", visible: false)
  end

  scenario "should see Twitter share button", js: true do
    visit campaign_path(campaign, anchor: 'share')
    expect(page).to have_css("a.share-on-twitter-button")
  end
end

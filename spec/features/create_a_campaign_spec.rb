require 'rails_helper'

feature 'Create a campaign', :type => :feature do

  let(:title) { Faker::Lorem.sentence }
  let(:description) { Faker::Lorem.paragraph }

  context 'when the campaign is valid' do
    let(:campaign) { Campaign.find_by title: title }

    scenario 'should create a campaign with valid data' do
      visit new_campaign_path
      within("form.new_campaign") do
        fill_in "campaign[title]", with: title
        fill_in "campaign[description]", with: description
        click_button "new-campaign-submit-button"
      end

      expect(campaign).to_not be_nil
    end

    scenario 'should redirect to the campaign page' do
      visit new_campaign_path
      within("form.new_campaign") do
        fill_in "campaign[title]", with: title
        fill_in "campaign[description]", with: description
        click_button "new-campaign-submit-button"
      end

      expect(current_path).to be_eql(campaign_path(campaign))
    end
  end

  context 'when the campaign is invalid' do
    scenario "should show me an error message", js: true do
      visit new_campaign_path
      click_button "new-campaign-submit-button"

      expect(page).to have_css("input#campaign_title[data-invalid]")
    end

    scenario 'should render the new campaign page', js: true  do
      visit new_campaign_path
      click_button "new-campaign-submit-button"

      expect(current_path).to be_eql(new_campaign_path)
    end
  end
end
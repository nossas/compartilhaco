require 'rails_helper'

feature "View all campains", :type => :feature do
  context "when there is no campaign" do
    it "should show an empty list" do
      visit root_path
      expect(page).to have_css(".campaigns .empty")
    end
  end

  context "when there is at least 6 campaigns" do
    before { 6.times { Campaign.make! } }

    it "should not show an empty list" do
      visit root_path
      expect(page).to_not have_css(".campaigns .empty")
    end

    it "should show all the 6 campaigns" do
      visit root_path
      expect(page).to have_css(".campaign", count: 6)
    end

    context "when one of these campaigns is archieved" do
      let(:campaign) { Campaign.first }
      before{ campaign.archive }

      it "should not show the archived campaign" do
        visit root_path
        expect(page).to_not have_css("#campaign-#{campaign.id}")
      end
    end

    context "when one of these campaigns is ended" do
      let(:campaign) { Campaign.first }
      before{ campaign.update_column :ends_at, 1.day.ago }

      it "should not show the ended campaign" do
        visit root_path
        expect(page).to_not have_css("#campaign-#{campaign.id}")
      end
    end
  end
end

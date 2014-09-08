require 'rails_helper'

feature "View all campains", :type => :feature do
  context "when there is no campaign" do
    it "should show an empty list" do
      visit root_path
      expect(page).to have_css(".campaigns .empty")
    end
  end

  context "when there are at least 6 campaigns" do
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

  context "when there are 12 campaigns" do
    before { 12.times { Campaign.make! } }

    it "should show 6 campaigns in the first page" do
      visit root_path
      expect(page).to have_css(".campaign", count: 6)
    end

    context "when the user scrolls down" do
      it "should show all the 12 campaigns", js: true do
        visit root_path
        page.execute_script('window.scrollTo(0,100000)')
        expect(page).to have_css(".campaign", count: 12)
      end
    end
  end

  context "when campaigns have different end dates" do
    before do
      @campaign_c = Campaign.make! ends_at: 3.day.from_now
      @campaign_b = Campaign.make! ends_at: 2.day.from_now
      @campaign_a = Campaign.make! ends_at: 1.day.from_now
    end

    it "should show campaigns ordered by end date" do
      visit root_path
      expect(page).to have_css(".campaign:nth-child(1)", text: @campaign_a.title)
      expect(page).to have_css(".campaign:nth-child(2)", text: @campaign_b.title)
      expect(page).to have_css(".campaign:nth-child(3)", text: @campaign_c.title)
    end
  end
end

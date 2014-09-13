require 'rails_helper'

feature "Report campaign as spam", :type => :feature do
  let(:user) { User.make! }
  before { @campaign = Campaign.make! }

  context "when the user is logged in" do
    before do
      page.set_rack_session('cas' => {'user' => user.email})
      visit campaign_path(@campaign)
    end

    it "should create a spam report for the campaign" do
      expect{ page.click_link "spam-report-button" }.to change{@campaign.spam_reports.count}.by(1)
    end

    it "should create a spam report for the user" do
      expect{ page.click_link "spam-report-button" }.to change{user.spam_reports.count}.by(1)
    end

    it "should show a successful message" do
      page.click_link "spam-report-button"
      expect(page).to have_css(".alert-box.secondary")
    end

    context "when the user already reported the campaign as spam" do
      before { SpamReport.make! user: user, campaign: @campaign }

      it "should not create another report" do
        expect{ page.click_link("spam-report-button") }.to_not change{SpamReport.count}
      end
    end
  end

  context "when the user is not logged in" do
    before { visit campaign_path(@campaign) }

    it "should not show the spam report button" do
      expect(page).to_not have_css("a#spam-report-button")
    end
  end
end

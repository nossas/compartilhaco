require 'rails_helper'

feature "Report campaign as spam", :type => :feature do
  let(:user) { User.make! }
  before { @campaign = Campaign.make! }

  context "when the user is logged in" do
    before { page.set_rack_session('cas' => {'user' => user.email}) }

    it "should show the spam report button" do
      visit campaign_path(@campaign)
      expect(page).to have_css(".spam-report a[href='/campaigns/#{@campaign.id}/spam_reports']")
    end

    context "when the user clicks in the report spam button" do
      it "should create a spam report for the campaign" do
        expect {
          visit campaign_path(@campaign)
          page.click_link "spam-report-button"
        }.to change{@campaign.spam_reports.count}.by(1)
      end

      it "should create a spam report for the user" do
        expect {
          visit campaign_path(@campaign)
          page.click_link "spam-report-button"
        }.to change{user.spam_reports.count}.by(1)
      end
    end
  end
end

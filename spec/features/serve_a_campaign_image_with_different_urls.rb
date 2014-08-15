require 'rails_helper'

feature "Serve a campaign image with different URLs", type: :feature do
  let(:campaign) { Campaign.make! image: File.open("#{Rails.root}/spec/support/images/rails.png") }
  
  describe "serve the campaign image with different urls" do

    it "returns the campaign image" do
      visit serve_image_campaign_path(campaign, trash: SecureRandom.uuid)
      # expect(page).to have_css('img')
    end

  end
end
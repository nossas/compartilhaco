require 'rails_helper'

feature "Become a campaign spreader with my Facebook profile", :type => :feature do
  let(:campaign){ Campaign.make! }

  scenario "when I'm a new user" do
    email = "nicolas@trashmail.com"

    visit campaign_path(campaign)
    fill_in "campaign_spreader[timeline][user][email]", with: email
    click_button "facebook-profile-campaign-spreader-submit-button"

    user = User.find_by_email(email)

    expect(user).to_not be_nil
    expect(user.facebook_profile).to_not be_nil
    expect(current_path).to be_eql(campaign_path(campaign))
    expect(page).to have_css(".alert-box")
  end

  # scenario "when the user exists" do
  #   scenario "when the user is logged in" do
  #     scenario "when the user have a Facebook authorization" do
  #     end
  #     scenario "when the user don't have a Facebook authorization" do
  #     end
  #   end
  #   scenario "when the user is not logged in" do
  #     scenario "when the user have a Facebook authorization" do
  #     end
  #     scenario "when the user don't have a Facebook authorization" do
  #     end
  #   end
  # end
end

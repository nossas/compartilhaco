require 'rails_helper'

feature "Become a campaign spreader with my Facebook profile", :type => :feature do
  let(:campaign){ Campaign.make! }

  scenario "when I'm a new user" do
    email = "nicolas@trashmail.com"
    facebook_uid = "123"

    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: facebook_uid,
      info: {
        first_name: "Nícolas",
        last_name: "Iensen"
      },
      credentials: {
        token: "abcde",
        expires_at: 1321747205
      }
    })

    visit campaign_path(campaign)
    fill_in "campaign_spreader[timeline][user][email]", with: email
    click_button "facebook-profile-campaign-spreader-submit-button"

    user = User.find_by_email(email)
    facebook_profile = user.facebook_profile
    campaign_spreaders = facebook_profile.campaign_spreaders

    expect(user).to_not be_nil
    expect(facebook_profile).to_not be_nil
    expect(facebook_profile.uid).to be_eql(facebook_uid)
    expect(campaign_spreaders).to have(1).campaign_spreader
    expect(current_path).to be_eql(campaign_path(campaign))
    expect(page).to have_css(".alert-box")
    expect(page.get_rack_session['campaign_spreader']).to be_nil
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

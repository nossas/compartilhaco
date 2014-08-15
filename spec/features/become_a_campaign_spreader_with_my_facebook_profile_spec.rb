require 'rails_helper'

feature "Become a campaign spreader with my Facebook profile", :type => :feature do
  let(:campaign){ Campaign.make! }
  let(:email){ "nicolas@trashmail.com" }
  let(:facebook_uid){ "123" }
  let(:expires_at){ 1321747205 }
  let(:token){ "abcde" }
  let(:ip){ "192.168.0.1" }

  before do
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: facebook_uid,
      info: {
        first_name: "Nícolas",
        last_name: "Iensen"
      },
      credentials: {
        token: token,
        expires_at: expires_at
      }
    })

    allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(ip)
  end

  context "when I'm a new user" do
    around(:each) { @me = User.find_by_email(email) }

    scenario "it should create an user with my email" do
      visit campaign_path(campaign)
      fill_in "campaign_spreader[timeline][user][email]", with: email
      click_button "facebook-profile-campaign-spreader-submit-button"

      expect(@me).to_not be_nil
    end

    scenario "it should save my ip address" do
      visit campaign_path(campaign)
      fill_in "campaign_spreader[timeline][user][email]", with: email
      click_button "facebook-profile-campaign-spreader-submit-button"

      expect(@me.ip).to be_eql(ip)
    end

    scenario "it should create a Facebook profile for me" do
      visit campaign_path(campaign)
      fill_in "campaign_spreader[timeline][user][email]", with: email
      click_button "facebook-profile-campaign-spreader-submit-button"

      expect(@me.facebook_profile).to_not be_nil
    end

    scenario "it should save my Facebook profile uid" do
      visit campaign_path(campaign)
      fill_in "campaign_spreader[timeline][user][email]", with: email
      click_button "facebook-profile-campaign-spreader-submit-button"

      expect(@me.facebook_profile.uid).to be_eql(facebook_uid)
    end

    scenario "it should make me a campaign spreader" do
      visit campaign_path(campaign)
      fill_in "campaign_spreader[timeline][user][email]", with: email
      click_button "facebook-profile-campaign-spreader-submit-button"

      expect(@me.facebook_profile.campaign_spreaders).to have(1).campaign_spreader
    end

    scenario "it should add a campaign spreader to the campaign" do
      visit campaign_path(campaign)
      fill_in "campaign_spreader[timeline][user][email]", with: email
      click_button "facebook-profile-campaign-spreader-submit-button"

      expect(campaign.campaign_spreaders).to have(1).campaign_spreader
    end

    scenario "it should redirect me to the campaign page" do
      visit campaign_path(campaign)
      fill_in "campaign_spreader[timeline][user][email]", with: email
      click_button "facebook-profile-campaign-spreader-submit-button"

      expect(current_path).to be_eql(campaign_path(campaign))
    end

    scenario "it should show me the alert box" do
      visit campaign_path(campaign)
      fill_in "campaign_spreader[timeline][user][email]", with: email
      click_button "facebook-profile-campaign-spreader-submit-button"

      expect(page).to have_css(".alert-box")
    end

    scenario "it should clean up my session" do
      visit campaign_path(campaign)
      fill_in "campaign_spreader[timeline][user][email]", with: email
      click_button "facebook-profile-campaign-spreader-submit-button"

      expect(page.get_rack_session['campaign_spreader']).to be_nil
    end
  end

  context "when I'm not a new user" do
    before { @user = User.make! email: email }

    context "when I'm not logged in" do
      context "when I don't have a Facebook profile" do
        scenario "it should create Facebook profile for me" do
          visit campaign_path(campaign)
          fill_in "campaign_spreader[timeline][user][email]", with: email
          click_button "facebook-profile-campaign-spreader-submit-button"

          expect(@user.facebook_profile).to_not be_nil
        end
      end

      context "when I have a Facebook profile" do
        before { @facebook_profile = FacebookProfile.make! user_id: @user.id, uid: facebook_uid }

        scenario "it should update my Facebook profile expiring date" do
          visit campaign_path(campaign)
          fill_in "campaign_spreader[timeline][user][email]", with: email
          click_button "facebook-profile-campaign-spreader-submit-button"

          expect(@facebook_profile.reload.expires_at).to be_eql(Time.at(expires_at))
        end

        scenario "it should update my Facebook profile token" do
          visit campaign_path(campaign)
          fill_in "campaign_spreader[timeline][user][email]", with: email
          click_button "facebook-profile-campaign-spreader-submit-button"

          expect(@facebook_profile.reload.token).to be_eql(token)
        end
      end
    end

    context "when I'm logged in" do
      before { page.set_rack_session('cas' => {'user' => @user.email}) }

      context "when I don't have a Facebook profile" do
        scenario "it should not show the user email field" do
          visit campaign_path(campaign)
          expect(page).to_not have_css("input[name='campaign_spreader[timeline][user][email]']")
        end

        scenario "it should create a Facebook profile for me" do
          visit campaign_path(campaign)
          click_button "facebook-profile-campaign-spreader-submit-button"
          expect(@user.facebook_profile).to_not be_nil
        end
      end

      context "when I have a Facebook profile" do
      end
    end
  end
end

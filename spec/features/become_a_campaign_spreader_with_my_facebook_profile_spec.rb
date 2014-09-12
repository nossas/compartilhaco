require 'rails_helper'

feature "Become a campaign spreader with my Facebook profile", :type => :feature do
  let(:campaign) { Campaign.make! }
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
    let(:me){ User.find_by_email(email) }

    scenario "should create an user with my email" do
      visit campaign_path(campaign)
      within("form.facebook-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "facebook-profile-campaign-spreader-submit-button"
      end

      expect(me).to_not be_nil
    end

    scenario "should save my ip address" do
      visit campaign_path(campaign)
      within("form.facebook-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "facebook-profile-campaign-spreader-submit-button"
      end

      expect(me.ip).to be_eql(ip)
    end

    scenario "should create a Facebook profile for me" do
      visit campaign_path(campaign)
      within("form.facebook-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "facebook-profile-campaign-spreader-submit-button"
      end

      expect(me.facebook_profile).to_not be_nil
    end

    scenario "should save my Facebook profile uid" do
      visit campaign_path(campaign)
      within("form.facebook-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "facebook-profile-campaign-spreader-submit-button"
      end

      expect(me.facebook_profile.uid).to be_eql(facebook_uid)
    end

    scenario "should make me a campaign spreader" do
      visit campaign_path(campaign)
      within("form.facebook-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "facebook-profile-campaign-spreader-submit-button"
      end

      expect(me.facebook_profile.campaign_spreaders).to have(1).campaign_spreader
    end

    scenario "should add a campaign spreader to the campaign" do
      visit campaign_path(campaign)
      within("form.facebook-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "facebook-profile-campaign-spreader-submit-button"
      end

      expect(campaign.campaign_spreaders).to have(1).campaign_spreader
    end

    scenario "should redirect me to the campaign page" do
      visit campaign_path(campaign)
      within("form.facebook-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "facebook-profile-campaign-spreader-submit-button"
      end

      expect(current_path).to be_eql(twitter_form_campaign_path(campaign))
    end

    scenario "should show me the alert box" do
      visit campaign_path(campaign)
      within("form.facebook-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "facebook-profile-campaign-spreader-submit-button"
      end

      expect(page).to have_css(".alert-box")
    end

    scenario "should clean up my session" do
      visit campaign_path(campaign)
      within("form.facebook-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "facebook-profile-campaign-spreader-submit-button"
      end

      expect(page.get_rack_session['campaign_spreader']).to be_nil
    end

    context "when I leave the email field blank" do
      scenario "should show me an error message", js: true do
        visit campaign_path(campaign)
        click_button "facebook-profile-campaign-spreader-submit-button"

        expect(page).to have_css("input#campaign_spreader_timeline_user_email[data-invalid]")
      end
    end

    context "when I fill the message field" do
      scenario "should save the message" do
        message = "My custom message"

        visit campaign_path(campaign)
        within("form.facebook-profile-campaign-spreader") do
          fill_in "campaign_spreader[message]", with: message
          fill_in "campaign_spreader[timeline][user][email]", with: email
          click_button "facebook-profile-campaign-spreader-submit-button"
        end

        expect(CampaignSpreader.first.message).to be_eql(message)
      end
    end
  end

  context "when I'm not a new user" do
    before { @user = User.make! email: email }

    context "when I'm not logged in" do
      context "when I don't have a Facebook profile" do
        scenario "should create Facebook profile for me" do
          visit campaign_path(campaign)
          within("form.facebook-profile-campaign-spreader") do
            fill_in "campaign_spreader[timeline][user][email]", with: email
            click_button "facebook-profile-campaign-spreader-submit-button"
          end

          expect(@user.facebook_profile).to_not be_nil
        end
      end

      context "when I have a Facebook profile" do
        before { @facebook_profile = FacebookProfile.make! user_id: @user.id, uid: facebook_uid }

        scenario "should update my Facebook profile expiring date" do
          visit campaign_path(campaign)
          within("form.facebook-profile-campaign-spreader") do
            fill_in "campaign_spreader[timeline][user][email]", with: email
            click_button "facebook-profile-campaign-spreader-submit-button"
          end

          expect(@facebook_profile.reload.expires_at).to be_eql(Time.at(expires_at))
        end

        scenario "should update my Facebook profile token" do
          visit campaign_path(campaign)
          within("form.facebook-profile-campaign-spreader") do
            fill_in "campaign_spreader[timeline][user][email]", with: email
            click_button "facebook-profile-campaign-spreader-submit-button"
          end

          expect(@facebook_profile.reload.token).to be_eql(token)
        end
      end
    end

    context "when I'm logged in" do
      before { page.set_rack_session('cas' => {'user' => @user.email}) }

      context "when I don't have a Facebook profile" do
        scenario "should not show the user email field" do
          visit campaign_path(campaign)
          within("form.facebook-profile-campaign-spreader") do
            expect(page).to_not have_css("input[name='campaign_spreader[timeline][user][email]']")
          end
        end

        scenario "should create a Facebook profile for me" do
          visit campaign_path(campaign)
          click_button "facebook-profile-campaign-spreader-submit-button"
          expect(@user.facebook_profile).to_not be_nil
        end
      end
    end
  end

  context "when I don't allow Facebook permitions" do
    before do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    end

    scenario "should show me an error message" do
      visit campaign_path(campaign)
      within("form.facebook-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "facebook-profile-campaign-spreader-submit-button"
      end

      expect(page).to have_css(".alert-box.alert")
    end
  end
end

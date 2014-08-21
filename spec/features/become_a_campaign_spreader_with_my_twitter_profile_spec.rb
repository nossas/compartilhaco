require 'rails_helper'

feature "Become a campaign spreader with my Twitter profile", :type => :feature do
  let(:campaign) { Campaign.make! }
  let(:email){ "nicolas@trashmail.com" }
  let(:ip){ "192.168.0.1" }
  let(:twitter_uid){ "123" }
  let(:expires_at){ 1321747205 }
  let(:token){ "abcde" }

  before do
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: twitter_uid,
      credentials: { token: token },
      info: { name: "Nícolas Iensen" }
    })

    allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(ip)
  end

  context "when I'm a new user" do
    let(:me){ User.find_by_email(email) }

    scenario "should create an user with my email" do
      visit campaign_path(campaign)
      within("form.twitter-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "twitter-profile-campaign-spreader-submit-button"
      end

      expect(me).to_not be_nil
    end

    scenario "should save my ip address" do
      visit campaign_path(campaign)
      within("form.twitter-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "twitter-profile-campaign-spreader-submit-button"
      end

      expect(me.ip).to be_eql(ip)
    end

    scenario "should create a Twitter profile for me" do
      visit campaign_path(campaign)
      within("form.twitter-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "twitter-profile-campaign-spreader-submit-button"
      end

      expect(me.twitter_profile).to_not be_nil
    end

    scenario "should save my Twitter profile uid" do
      visit campaign_path(campaign)
      within("form.twitter-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "twitter-profile-campaign-spreader-submit-button"
      end

      expect(me.twitter_profile.uid).to be_eql(twitter_uid)
    end

    scenario "should make me a campaign spreader" do
      visit campaign_path(campaign)
      within("form.twitter-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "twitter-profile-campaign-spreader-submit-button"
      end

      expect(me.twitter_profile.campaign_spreaders).to have(1).campaign_spreader
    end

    scenario "should add a campaign spreader to the campaign" do
      visit campaign_path(campaign)
      within("form.twitter-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "twitter-profile-campaign-spreader-submit-button"
      end

      expect(campaign.campaign_spreaders).to have(1).campaign_spreader
    end

    scenario "should redirect me to the campaign page" do
      visit campaign_path(campaign)
      within("form.twitter-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "twitter-profile-campaign-spreader-submit-button"
      end

      expect(current_path).to be_eql(campaign_path(campaign))
    end

    scenario "should show me the alert box" do
      visit campaign_path(campaign)
      within("form.twitter-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "twitter-profile-campaign-spreader-submit-button"
      end

      expect(page).to have_css(".alert-box")
    end

    scenario "should clean up my session" do
      visit campaign_path(campaign)
      within("form.twitter-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "twitter-profile-campaign-spreader-submit-button"
      end

      expect(page.get_rack_session['campaign_spreader']).to be_nil
    end

    context "when I leave the email field blank" do
      scenario "should show me an error message", js: true do
        visit campaign_path(campaign)
        click_button "twitter-profile-campaign-spreader-submit-button"

        within("form.twitter-profile-campaign-spreader") do
          expect(page).to have_css("input#campaign_spreader_timeline_user_email[data-invalid]")
        end
      end
    end

    context "when I fill the message field" do
      scenario "should save the message" do
        message = "My custom message"

        visit campaign_path(campaign)
        within("form.twitter-profile-campaign-spreader") do
          fill_in "campaign_spreader[message]", with: message
          fill_in "campaign_spreader[timeline][user][email]", with: email
          click_button "twitter-profile-campaign-spreader-submit-button"
        end

        expect(CampaignSpreader.first.message).to be_eql(message)
      end
    end
  end

  context "when I'm not a new user" do
    before { @user = User.make! email: email }

    context "when I'm not logged in" do
      context "when I don't have a Twitter profile" do
        scenario "should create Twitter profile for me" do
          visit campaign_path(campaign)
          within("form.twitter-profile-campaign-spreader") do
            fill_in "campaign_spreader[timeline][user][email]", with: email
            click_button "twitter-profile-campaign-spreader-submit-button"
          end
          expect(@user.twitter_profile).to_not be_nil
        end
      end

      context "when I have a Twitter profile" do
        before { @twitter_profile = TwitterProfile.make! user_id: @user.id, uid: twitter_uid }
        scenario "should update my Twitter profile token" do
          visit campaign_path(campaign)
          within("form.twitter-profile-campaign-spreader") do
            fill_in "campaign_spreader[timeline][user][email]", with: email
            click_button "twitter-profile-campaign-spreader-submit-button"
          end
          expect(@twitter_profile.reload.token).to be_eql(token)
        end
      end
    end

    context "when I'm logged in" do
      before { page.set_rack_session('cas' => {'user' => @user.email}) }

      context "when I don't have a Twitter profile" do
        scenario "should not show the user email field" do
          visit campaign_path(campaign)
          within("form.twitter-profile-campaign-spreader") do
            expect(page).to_not have_css("input[name='campaign_spreader[timeline][user][email]']")
          end
        end

        scenario "should create a Twitter profile for me" do
          visit campaign_path(campaign)
          click_button "twitter-profile-campaign-spreader-submit-button"
          expect(@user.twitter_profile).to_not be_nil
        end
      end
    end
  end

  context "when I don't allow Twitter permitions" do
    before do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
    end

    scenario "should show me an error message" do
      visit campaign_path(campaign)
      within("form.twitter-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "twitter-profile-campaign-spreader-submit-button"
      end

      expect(page).to have_css(".alert-box.alert")
    end
  end
end

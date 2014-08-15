require 'rails_helper'

feature "Become a campaign spreader with my Facebook profile", :type => :feature do
  let(:campaign){ Campaign.make! }
  let(:email){ "nicolas@trashmail.com" }
  let(:facebook_uid){ "123" }
  let(:expires_at){ 1321747205 }
  let(:token){ "abcde" }

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
  end

  scenario "when I'm a new user" do
    ip = "192.168.0.1"

    allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(ip)

    visit campaign_path(campaign)
    fill_in "campaign_spreader[timeline][user][email]", with: email
    click_button "facebook-profile-campaign-spreader-submit-button"

    user = User.find_by_email(email)

    expect(user).to_not be_nil
    expect(user.ip).to be_eql(ip)
    expect(user.facebook_profile).to_not be_nil
    expect(user.facebook_profile.uid).to be_eql(facebook_uid)
    expect(user.facebook_profile.campaign_spreaders).to have(1).campaign_spreader
    expect(campaign.campaign_spreaders).to have(1).campaign_spreader
    expect(current_path).to be_eql(campaign_path(campaign))
    expect(page).to have_css(".alert-box")
    expect(page.get_rack_session['campaign_spreader']).to be_nil
  end

  context "when I'm not a new user" do
    before { @user = User.make! email: email }

    context "when I'm not logged in" do
      scenario "when I don't have a Facebook profile" do
        expect(User).to_not receive(:create)

        visit campaign_path(campaign)
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "facebook-profile-campaign-spreader-submit-button"

        user = User.find_by_email(email)

        expect(user.facebook_profile).to_not be_nil
        expect(user.facebook_profile.uid).to be_eql(facebook_uid)
        expect(user.facebook_profile.campaign_spreaders).to have(1).campaign_spreader
        expect(campaign.campaign_spreaders).to have(1).campaign_spreader
        expect(current_path).to be_eql(campaign_path(campaign))
        expect(page).to have_css(".alert-box")
        expect(page.get_rack_session['campaign_spreader']).to be_nil
      end

      scenario "when I have a Facebook profile" do
        facebook_profile = FacebookProfile.make! user_id: @user.id, uid: facebook_uid

        visit campaign_path(campaign)
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "facebook-profile-campaign-spreader-submit-button"

        expect(facebook_profile.reload.expires_at).to be_eql(Time.at(expires_at))
        expect(facebook_profile.reload.token).to be_eql(token)
      end
    end

    context "when I'm logged in" do
      before { page.set_rack_session('cas' => {'user' => @user.email}) }

      scenario "when I don't have a Facebook profile" do
        visit campaign_path(campaign)
        expect(page).to_not have_css("input[name='campaign_spreader[timeline][user][email]']")

        click_button "facebook-profile-campaign-spreader-submit-button"
        expect(@user.facebook_profile).to_not be_nil
      end

      scenario "when I have a Facebook profile" do
      end
    end
  end
end

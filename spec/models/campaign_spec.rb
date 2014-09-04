require 'rails_helper'

RSpec.describe Campaign, :type => :model do
  it { should have_many :campaign_spreaders }
  it { should belong_to :organization }
  it { should belong_to :user }
  it { should belong_to :category }
  it { should validate_presence_of :ends_at }
  it { should validate_presence_of :share_link }
  it { should validate_presence_of :goal }
  it { should validate_presence_of :organization_id }
  it { should validate_presence_of :image }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :short_description }
  it { should validate_presence_of :share_title }
  it { should validate_presence_of :share_image }
  it { should validate_presence_of :share_description }
  it { should validate_presence_of :tweet }
  it { should ensure_length_of(:short_description).is_at_most(250) }

  context "when the ends_at is in the past" do
    subject { Campaign.make ends_at: 1.hour.ago }
    it { should have(1).error_on(:ends_at) }
  end

  context "when the ends_at is in more than 50 days from now" do
    subject { Campaign.make ends_at: 51.days.from_now }
    it { should have(1).error_on(:ends_at) }
  end

  describe ".succeeded" do
    context "when there is at least one succeeded campaign" do
      before { CampaignSpreader.make!(:facebook_profile, campaign: Campaign.make!(goal: 1)) }

      it "should have one campaign" do
        expect(Campaign.succeeded).to have(1).campaign
      end
    end

    context "when there is no succeeded campaign" do
      before { Campaign.make! }

      it "should be empty" do
        expect(Campaign.succeeded).to be_empty
      end
    end
  end

  describe ".upcoming" do
    context "when there is at least one upcoming campaign" do
      before do
        Campaign.make! ends_at: 10.days.from_now
      end

      it "should have one campaign" do
        expect(Campaign.upcoming).to have(1).campaign
      end
    end

    context "when there is no upcoming campaign" do
      before do
        Campaign.make! ends_at: 1.day.from_now
        allow(Time).to receive(:now).and_return(2.days.from_now)
      end

      it "should be empty" do
        expect(Campaign.upcoming).to be_empty
      end
    end
  end

  describe ".ended" do
    context "when there is at least one ended campaign" do
      before do
        Campaign.make! ends_at: 1.day.from_now
        allow(Time).to receive(:now).and_return(2.days.from_now)
      end

      it "should have one campaign" do
        expect(Campaign.ended).to have(1).campaign
      end
    end

    context "when there is no ended campaign" do
      before { Campaign.make! ends_at: Time.now + 1.day }

      it "should be empty" do
        expect(Campaign.ended).to be_empty
      end
    end
  end

  describe ".unshared" do
    context "when there is at least one unshared campaign" do
      before { Campaign.make! }

      it "should have one campaign" do
        expect(Campaign.unshared).to have(1).campaign
      end
    end

    context "when there is no unshared campaign" do
      before { Campaign.make! shared_at: Time.now }

      it "should be empty" do
        expect(Campaign.unshared).to be_empty
      end
    end
  end

  describe "#share" do
    subject { Campaign.make! }
    before { @campaign_spreader = CampaignSpreader.make!(:facebook_profile, campaign: subject) }

    it "should call campaign_spreader#share method" do
      expect{
        VCR.use_cassette('facebook profile share', match_requests_on: [:host, :path]) do
          subject.share
        end
      }.to change{@campaign_spreader.reload.uid}.from(nil).to("10152278257287843_10152330512207843")
    end

    it "should update shared_at" do
      time = Time.now
      allow(Time).to receive(:now).and_return(time)

      expect{
        subject.share
      }.to change{subject.shared_at}.from(nil).to(time)
    end
  end

  describe "#facebook_profiles" do
    subject { Campaign.make! }

    context "when there is at least one facebook profile" do
      before { CampaignSpreader.make!(:facebook_profile, campaign: subject) }

      it "should have one facebook profile" do
        expect(subject.facebook_profiles).to have(1).facebook_profile
      end
    end

    context "when there is no facebook profile" do
      it "should be empty" do
        expect(subject.facebook_profiles).to be_empty
      end
    end
  end

  describe "#twitter_profiles" do
    subject { Campaign.make! }

    context "when there is at least one twitter profile" do
      before { CampaignSpreader.make!(:twitter_profile, campaign: subject) }

      it "should have one twitter profile" do
        expect(subject.twitter_profiles).to have(1).twitter_profile
      end
    end

    context "when there is no twitter profile" do
      it "should be empty" do
        expect(subject.twitter_profiles).to be_empty
      end
    end
  end

  describe "#check_expired_tokens" do
    subject { Campaign.make! }

    context "when there is a facebook profile" do
      let(:profile) { double() }
      before { allow(subject).to receive(:facebook_profiles).and_return([ profile ]) }

      it "should call FacebookProfile#check_expired_token" do
        expect(profile).to receive(:check_expired_token)
        subject.check_expired_tokens
      end
    end
  end

  describe "#progress_of_success" do
    context "when the timeline target is 2" do
      subject { Campaign.make! goal: 2 }

      context "when there is no campaign spreader" do
        it "should be zero" do
          expect(subject.progress_of_goal).to be_zero
        end
      end

      context "when there is one campaign spreader" do
        before { CampaignSpreader.make! :facebook_profile, campaign: subject }
        it "should be 50" do
          expect(subject.progress_of_goal).to be_eql(50.0)
        end
      end

      context "when there are two campaign spreaders" do
        before { 2.times { CampaignSpreader.make! :facebook_profile, campaign: subject } }
        it "should be 100" do
          expect(subject.progress_of_goal).to be_eql(100.0)
        end
      end
    end
  end

  describe "#progress_of_the_end" do
    context "when it's duration is 2 days" do
      subject { Campaign.make! ends_at: 2.days.from_now }

      context "when it's day 0" do
        before { allow(Time).to receive(:now).and_return(subject.created_at) }
        it "should be zero" do
          expect(subject.progress_of_time).to be_zero
        end
      end

      context "when it's day 1" do
        before { allow(Time).to receive(:now).and_return(subject.created_at + 1.day) }
        it "should be 50" do
          expect(subject.progress_of_time).to be_within(0.1).of(50.0)
        end
      end

      context "when it's day 2" do
        before { allow(Time).to receive(:now).and_return(subject.created_at + 2.days) }
        it "should be 100" do
          expect(subject.progress_of_time).to be_within(0.1).of(100.0)
        end
      end
    end
  end

  describe "#reach" do
    subject { Campaign.make! }

    context "when there is no campaign spreader" do
      it "should be zero" do
        expect(subject.reach).to be_zero
      end
    end

    context "when there is a campaign spreader for Facebook profile with 100 friends" do
      let(:facebook_profile){ FacebookProfile.make! friends_count: 100 }
      before { CampaignSpreader.make!(:facebook_profile, campaign: subject, timeline: facebook_profile) }

      it "should be 100" do
        expect(subject.reach).to be_eql(100)
      end

      context "when this Facebook profile has also 100 subscribers" do
        before { facebook_profile.update_attribute :subscribers_count, 100 }

        it "should be 200" do
          expect(subject.reach).to be_eql(200)
        end
      end
    end

    context "when there is a campaign spreader for Twitter profile with 100 followers" do
      let(:twitter_profile){ TwitterProfile.make! followers_count: 100 }
      before { CampaignSpreader.make!(:twitter_profile, campaign: subject, timeline: twitter_profile) }

      it "should be 100" do
        expect(subject.reach).to be_eql(100)
      end
    end
  end
end

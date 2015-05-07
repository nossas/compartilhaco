class CampaignSpreader < ActiveRecord::Base
  belongs_to :timeline, polymorphic: true
  belongs_to :campaign

  validates :timeline_id, :timeline_type, :campaign_id, presence: true
  validates :timeline_id, uniqueness: { scope: [:timeline_type, :campaign_id] }
  validates_length_of :message, maximum: 140, if: :facebook?

  delegate :user, :service, to: :timeline

  after_create { CampaignSpreaderWorker.perform_async(self.id) }

  def share
    timeline.share(self) if uid.blank?
  end

  def facebook?
    timeline_type == "FacebookProfile"
  end

  # TODO: move it to a gem
  def create_segment_subscription
    url = "#{ENV["ACCOUNTS_HOST"]}/users/#{timeline.user_id}/segment_subscriptions.json"

    body = {
      token: ENV["ACCOUNTS_API_TOKEN"],
      segment_subscription: { segment_id: campaign.mailchimp_segment_uid }
    }

    HTTParty.post(url, body: body.to_json, headers: { 'Content-Type' => 'application/json' })
  end
end

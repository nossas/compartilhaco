class AddMailchimpSegmentUidToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :mailchimp_segment_uid, :string
  end
end

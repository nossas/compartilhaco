class SpamReport < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign

  validates :user_id, uniqueness: { scope: :campaign_id }

  after_create { SpamReportWorker.perform_async(self.id) }
end

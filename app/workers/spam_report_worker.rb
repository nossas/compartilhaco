class SpamReportWorker
  include Sidekiq::Worker

  def perform spam_report_id
    spam_report = SpamReport.find(spam_report_id)
    Notifier.new_spam_report(spam_report).deliver
  end
end

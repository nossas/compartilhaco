require 'rails_helper'

RSpec.describe SpamReportWorker, :type => :worker do
  describe "#perform" do
    let(:spam_report) do
      double(
        "spam_report",
        id: 1
      )
    end

    before { allow(SpamReport).to receive(:find).with(spam_report.id).and_return(spam_report) }

    it "should send the new spam report email" do
      mail = double
      allow(Notifier).to receive(:new_spam_report).with(spam_report).and_return(mail)
      expect(mail).to receive(:deliver)
      subject.perform(spam_report.id)
    end
  end
end

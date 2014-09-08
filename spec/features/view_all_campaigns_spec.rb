require 'rails_helper'

feature "View all campains", :type => :feature do
  context "when there is no campaign" do
    it "should show an empty list" do
      visit root_path
      expect(page).to have_css(".campaigns .empty")
    end
  end
end

require 'rails_helper'

feature 'Create a campaign', :type => :feature do

  let(:email) { Faker::Internet.email }
  let(:user) { User.make! email: email }
  let(:title) { Faker::Lorem.sentence }
  let(:campaign) { Campaign.find_by title: title }
  before do
    @organization = Organization.make!
    @category = Category.make!
  end

  def fill_in_campaign_form
    within('form.new_campaign') do
      fill_in 'campaign[facebook_title]', with: title
      fill_in 'campaign[facebook_message]', with: Faker::Lorem.paragraph
      attach_file 'campaign[facebook_image]', "#{Rails.root}/spec/support/images/whale.jpg"
      fill_in 'campaign[title]', with: title
      select @organization.city, from: 'campaign[organization_id]'
      select @category.name, from: 'campaign[category_id]'
      fill_in 'campaign[short_description]', with: Faker::Lorem.sentence
      fill_in 'campaign[description]', with: Faker::Lorem.paragraph
      attach_file 'campaign[image]', "#{Rails.root}/spec/support/images/whale.jpg"
      fill_in 'campaign[share_link]', with: Faker::Internet.url
      fill_in 'campaign[tweet]', with: Faker::Lorem.sentence
      fill_in 'campaign[ends_at]', with: 1.month.from_now
      fill_in 'campaign[goal]', with: Faker::Number.number(3)
      fill_in 'campaign[new_campaign_spreader_mail]', with: Faker::Lorem.paragraph
      click_button 'campaign-submit-button'
    end
  end
end

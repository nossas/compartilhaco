require 'machinist/active_record'

Campaign.blueprint do
  facebook_title { "Campaign #{sn}" }
  facebook_message { Faker::Lorem.paragraph }
  facebook_image { File.new("#{Rails.root}/spec/support/images/whale.jpg") }
  share_link { "http://www.minhascidades.org.br/" }
  ends_at { 1.month.from_now }
  goal { 100 }
  organization { Organization.make! }
  title { "Campaign #{sn}" }
  image { File.new("#{Rails.root}/spec/support/images/whale.jpg") }
  description { Faker::Lorem.paragraph(3) }
  user { User.make! }
  category { Category.make! }
  tweet { Faker::Lorem.sentence }
  new_campaign_spreader_mail { Faker::Lorem.paragraph(3) }
  short_description { Faker::Lorem.sentence }
end

CampaignSpreader.blueprint(:facebook_profile) do
  timeline { FacebookProfile.make! }
  campaign { Campaign.make! }
end

CampaignSpreader.blueprint(:twitter_profile) do
  timeline { TwitterProfile.make! }
  campaign { Campaign.make! }
end

User.blueprint do
  email { Faker::Internet.email }
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
end

User.blueprint(:admin) do
  admin { true }
end

FacebookProfile.blueprint do
  uid { "uid-#{sn}" }
  token { "token-#{sn}" }
  expires_at { 60.days.from_now }
  user { User.make! }
end

TwitterProfile.blueprint do
  user { User.make! }
  uid { "uid-#{sn}" }
  token { "token-#{sn}" }
  secret { "secret-#{sn}" }
end

Organization.blueprint do
  email_signature_html { Faker::Lorem.sentence }
  city { Faker::Lorem.word }
end

Category.blueprint do
  name { "Category #{sn}" }
end

SpamReport.blueprint do
  user { User.make! }
  campaign { Campaign.make! }
end

Mobilization.blueprint do
  title { "Mob #{sn}" }
  hashtag { "Hash#{sn}" }
end

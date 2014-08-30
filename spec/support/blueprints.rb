require 'machinist/active_record'

Campaign.blueprint do
  share_link { "http://www.minhascidades.org.br/" }
  ends_at { 1.month.from_now }
  goal { 100 }
  organization { Organization.make! }
  title { "Campaign #{sn}" }
  image { File.new("#{Rails.root}/spec/support/images/whale.jpg") }
  description { Faker::Lorem.paragraph(3) }
  user { User.make! }
  category { Category.make! }
  short_description { Faker::Lorem.sentence }
  share_image { File.new("#{Rails.root}/spec/support/images/whale.jpg") }
  share_title { Faker::Lorem.sentence }
  share_description { Faker::Lorem.paragraph(3) }
  tweet { Faker::Lorem.sentence }
  timelines_target { 100 }
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
  # Attributes here
end

Category.blueprint do
  name { "Category #{sn}" }
end

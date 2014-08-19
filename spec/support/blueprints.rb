require 'machinist/active_record'

Campaign.blueprint do
end

CampaignSpreader.blueprint do
  # Attributes here
end

User.blueprint do
  # Attributes here
end

FacebookProfile.blueprint do
  uid { "uid-#{sn}" }
  token { "token-#{sn}" }
  expires_at { Time.now + 60.days }
  user { User.make! }
end

Timeline.blueprint do
  # Attributes here
end

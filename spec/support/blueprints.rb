require 'machinist/active_record'

Campaign.blueprint do
  share_link { "http://www.minhascidades.org.br/" }
end

CampaignSpreader.blueprint(:facebook_profile) do
  timeline { FacebookProfile.make! }
  campaign { Campaign.make! }
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

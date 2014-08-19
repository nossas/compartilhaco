namespace :compartilhaco do
  namespace :facebook do
    task :check_expired_tokens => :environment do
      # TODO: get only active campaigns
      Campaign.all.each do |campaign| 
        # get all spreaders belonging to FacebookProfiles
        campaign.campaign_spreaders.where(timeline_type: 'FacebookProfile').each do |spreader|
          # TODO: verify token validity
          if spreader.timeline.token # expired?
              # flag the token as expired
              spreader.timeline.update expires_at: Time.now
          end
        end
      end
    end
  end
end

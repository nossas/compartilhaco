namespace :compartilhaco do
  namespace :facebook do
    task :check_expired_tokens => :environment do
      # TODO: get only active campaigns
      Campaign.all.each do |campaign|
        campaign.campaign_spreaders.where(timeline_type: 'FacebookProfile').each do |spreader|
          begin
            Koala::Facebook::API.new(spreader.timeline.token).get_object('me')
          rescue => e
            puts e.message
            spreader.timeline.update(expires_at: Time.now) if e.message.include?("OAuthException: Error validating access token:")
          end
        end
      end
    end
  end

  task :share_campaigns => :environment do
    # Campaign.where("shared_at IS NULL AND ? >= share_at AND timelines_count >= timelines_target")
    Campaign.unshared.ended.succeeded.each {|c| c.share}
  end
end

class CreateViewTwitterProfileSpreaders < ActiveRecord::Migration
  def change
    create_view :twitter_profile_spreaders, "
      SELECT cs.id, tp.user_id, cs.created_at, cs.campaign_id
      FROM campaign_spreaders cs
      JOIN twitter_profiles tp
      ON cs.timeline_id = tp.id AND cs.timeline_type = 'TwitterProfile';"
  end
end

class CreateViewFacebookProfileSpreaders < ActiveRecord::Migration
  def change
    create_view :facebook_profile_spreaders, "
      SELECT cs.id, fp.user_id, cs.created_at, cs.campaign_id
      FROM campaign_spreaders cs
      JOIN facebook_profiles fp
      ON cs.timeline_id = fp.id AND cs.timeline_type = 'FacebookProfile';"
  end
end

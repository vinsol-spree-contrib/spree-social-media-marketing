class AddThresholdToSpreeSocialMediaMarketingEvents < ActiveRecord::Migration
  def change
    add_column :spree_social_media_marketing_events, :threshold, :integer
  end
end

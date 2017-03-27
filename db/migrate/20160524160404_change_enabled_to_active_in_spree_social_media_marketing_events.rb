class ChangeEnabledToActiveInSpreeSocialMediaMarketingEvents < ActiveRecord::Migration
  def change
    rename_column :spree_social_media_marketing_events, :enabled, :active
  end
end
